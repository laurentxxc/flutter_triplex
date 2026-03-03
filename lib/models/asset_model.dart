// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'dart:math';

class Asset {
  final List<int> values;

  Asset({required this.values});

  int get size => values.length;

  int valueAt(int position) => values[position];

  @override
  String toString() => values.map((v) => v.toString()).join('');

  @override
  bool operator ==(Object other) =>
      other is Asset && toString() == other.toString();

  @override
  int get hashCode => toString().hashCode;
}

class AssetCollection {
  /// Number of assets in a collection
  static const int nbAssets = 24;
  static const bool debug =
      String.fromEnvironment('DEBUG_ASSETS', defaultValue: 'false') == 'true';

  List<Asset> assets = [];

  late AssetsFactory? factory;

  /// Initialize the collection with a random set of assets making sure there is at least one matching set of assets
  AssetCollection({this.factory}) {
    factory ??= AssetsFactory.singleton;

    if (debug) {
      List<int> debugAssetValues = List.filled(factory!.nbCriteriaPerAsset, 1);
      assets = List.filled(nbAssets, Asset(values: debugAssetValues));
    } else {
      final int nbMatchingAssets = nbAssets ~/ 2;
      int fillidx = 0;
      // start filling with matching asset
      while (fillidx < nbMatchingAssets) {
        assets += factory!.generateMatchingAssets(3);
        fillidx += factory!.nbValuesPerCriteria;
      }

      // complet with random asset
      while (fillidx < nbAssets) {
        assets.add(factory!.generateRandomAsset());
        fillidx += 1;
      }

      assets.shuffle();
    }
  }

  Asset assetAt(int position) => assets[position];

  int getMatchingLevel(List<int> positions) {
    List<Asset> selectedAssets = [];
    for (int pos in positions) {
      selectedAssets.add(assets[pos]);
    }
    return factory!.checkAssets(selectedAssets);
  }

  /// Update collection by replacing assets at given positions with new random assets making sure there is at least
  /// one matching set of assets
  void updateCollection(List<int> positions) {
    positions.shuffle();
    for (int i = 0; i < positions.length - 1; i++) {
      assets[positions[i]] = factory!.generateRandomAsset();
    }

    // for last one generate a matching asset with 2 others form the board randomly selected
    final iA3 = positions[positions.length - 1];
    int iA1, iA2 = 0;

    do {
      iA1 = Random().nextInt(assets.length);
    } while (positions.contains(iA1));

    do {
      iA2 = Random().nextInt(assets.length);
    } while (positions.contains(iA2) || iA2 == iA1);

    assets[iA3] = factory!.generateMatchingAsset(
      assets[iA1],
      assets[iA2],
    );
  }
}

class AssetsFactory {
  final int nbCriteriaPerAsset;
  final int nbValuesPerCriteria = 3;
  static const int sum1_3 = 6;
  static const int facto3 = 6;
  static const List<int> root3 = [0, 1, 8, 27];

  static final AssetsFactory singleton = AssetsFactory._();
  static final AssetsFactory singletonEasy = AssetsFactory._(nbCriteriaPerAsset: 3);

  AssetsFactory._({this.nbCriteriaPerAsset = 4});

  Asset generateMatchingAsset(Asset first, Asset second) {
    List<int> matchingAssetContent = List.filled(nbCriteriaPerAsset, 0);

    for (int i = 0; i < nbCriteriaPerAsset; i++) {
      int v1 = first.valueAt(i);
      int v2 = second.valueAt(i);
      matchingAssetContent[i] = (v1 == v2 ? v1 : sum1_3 - (v1 + v2));
    }
    return Asset(values: matchingAssetContent);
  }

  Asset generateRandomAsset() {
    List<int> randomContent = [];
    for (int i = 0; i < nbCriteriaPerAsset; i++) {
      randomContent.add(Random().nextInt(nbValuesPerCriteria) + 1);
    }
    return Asset(values: randomContent);
  }

  List<Asset> generateMatchingAssets(int matchingLevel) {
    if (matchingLevel < 0 || matchingLevel > nbCriteriaPerAsset) {
      throw ArgumentError(
        'matchingLevel must be between 0 and $nbCriteriaPerAsset',
      );
    }

    int variantStartPosition = Random().nextInt(nbCriteriaPerAsset);
    int variantIncPosition = Random().nextInt(nbCriteriaPerAsset - 1) + 1;

    List<int> tempAssetContent = [];
    for (int i = 0; i < nbCriteriaPerAsset; i++) {
      tempAssetContent.add(Random().nextInt(nbValuesPerCriteria) + 1);
    }
    List<Asset> result = [Asset(values: List.from(tempAssetContent))];

    for (int i = 1; i <= nbValuesPerCriteria; i++) {
      for (int j = 0; j < (nbCriteriaPerAsset - matchingLevel); j++) {
        int pos =
            (variantStartPosition + j * variantIncPosition) %
            nbCriteriaPerAsset;
        tempAssetContent[pos] =
            (tempAssetContent[pos] % nbValuesPerCriteria) + 1;
      }
      result.add(Asset(values: List.from(tempAssetContent)));
    }

    return result;
  }

  int checkAssets(List<Asset> assets) {
    if (assets.length != nbValuesPerCriteria) {
      throw ArgumentError('checkAssets: wrong number of assets');
    }
    int matchingCriteria = 0;

    for (int i = 0; i < nbCriteriaPerAsset; i++) {
      int prod = 1;
      for (int j = 0; j < nbValuesPerCriteria; j++) {
        prod *= assets[j].valueAt(i);
      }

      if (prod != facto3) {
        if (prod == root3[assets[0].valueAt(i)]) {
          matchingCriteria++;
        } else {
          return -1;
        }
      }
    }
    return matchingCriteria;
  }
}
