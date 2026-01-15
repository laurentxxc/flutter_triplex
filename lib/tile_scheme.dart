// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'package:flutter/material.dart';
import 'asset_model.dart';

class TileView extends StatelessWidget {
  // View representation of a tile for a given asset
  // TODO: this class is currently limited for asset with 4 criteria and 3 values per criteria
  // Mapping of criteria:
  // 1 - symbol type (flag, crown, heart)
  // 2 - nb of same repeated symbol
  // 3 - symbol color (blue, red, green)
  // 4 - background color (cyan, pink, light green)

  static const _symbols = [
    ['⚑', '♛', '♥︎'],
    ['⚑⚑', '♛♛', '♥︎♥︎'],
    ['⚑⚑⚑', '♛♛♛', '♥︎♥︎♥︎'],
    //    ['⚑♛⚽︎', '♛⚑⚽︎', '♛⚑⚽︎']
  ];
  static const _symbolsColors = [
    Color.fromARGB(255, 66, 59, 255),
    Color.fromARGB(255, 255, 66, 60),
    Color.fromARGB(255, 37, 125, 49),
  ];
  static const _backgroundColors = [
    Color.fromARGB(255, 115, 253, 255),
    Color.fromARGB(255, 239, 184, 237),
    Color.fromARGB(255, 166, 255, 186),
  ];
  static const _fontSizes = [60.0, 40.0, 25.0];

  static final Map<Asset, TileView> _cache = {};

  final String symbol;
  final double fontSize;
  final Color fgColor;
  final Color bgColor;

  const TileView({
    Key? key,
    required this.symbol,
    required this.fontSize,
    required this.fgColor,
    required this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Center(
        child: Text(
          symbol,
          style: TextStyle(color: fgColor, fontSize: fontSize),
        ),
      ),
    );
  }

  static TileView fromAsset(Asset asset) {
    if (_cache.containsKey(asset)) {
      return _cache[asset]!;
    } else {
      TileView tv = _createTileViewFromAsset(asset);
      _cache[asset] = tv;
      return tv;
    }
  }

  static TileView _createTileViewFromAsset(Asset asset) {
    // criteria 1 & 2
    String label = _symbols[asset.valueAt(1) - 1][asset.valueAt(0) - 1];
    double fontSize = _fontSizes[asset.valueAt(1) - 1];
    // criteria 3
    Color fgColor = _symbolsColors[asset.valueAt(2) - 1];
    // criteria 4
    Color bgColor = _backgroundColors[asset.valueAt(3) - 1];

    TileView tv = TileView(
      symbol: label,
      fontSize: fontSize,
      fgColor: fgColor,
      bgColor: bgColor,
    );

    return tv;
  }
}
