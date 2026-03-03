// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'package:flutter/material.dart';
import 'models/asset_model.dart';

class TileView extends StatelessWidget {
  // View representation of a tile for a given asset
  // TODO: this class is currently limited for asset with 4 criteria and 3 values per criteria
  // TODO: this currently returning tile view with fixed 100x100 size
  static const double tileViewSize = 100;

  // Mapping of criteria:
  // 1 - symbol type (flag, crown, heart)
  // 2 - nb of same repeated symbol
  // 3 - symbol color (blue, red, green)
  // 4 - background color (cyan, pink, light green)

// custom font for symbol ♥︎ => '0', ♛ => '1' and ⚑ => '2'
  static final symbolStyle =TextStyle(fontFamily: 'triplex');

  static const _symbols = [
    ['0', '1', '2'],
    ['00', '11', '22'],
    ['000', '111', '222'],
  ];
  static const _symbolsColors = [
    Color.fromARGB(255, 66, 59, 255),
    Color.fromARGB(255, 255, 66, 60),
    Color.fromARGB(255, 37, 125, 49),
  ];
  static const _backgroundColors = [
    Color.fromARGB(255, 148, 253, 255),
    Color.fromARGB(255, 248, 202, 246),
    Color.fromARGB(255, 175, 247, 191),
  ];

  static final _backgroundGradients = [
    RadialGradient(colors: [ _backgroundColors[0],Colors.black ], center:Alignment.center, radius:3.0),
    RadialGradient(colors: [ _backgroundColors[1],Colors.black ], center:Alignment.center, radius:3.0),
    RadialGradient(colors: [ _backgroundColors[2],Colors.black ], center:Alignment.center, radius:3.0),
  ];
  
  static const _fontSizes = [70.0, 45.0, 30.0];

  static final Map<Asset, TileView> _cache = {};

  final String symbol;
  final double fontSize;
  final Color fgColor;
  final RadialGradient bgColor;

  const TileView({
    super.key,
    required this.symbol,
    required this.fontSize,
    required this.fgColor,
    required this.bgColor,
  });

  static Widget empty() {
    return SizedBox(width: tileViewSize, height: tileViewSize,);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<Shadow> shadows = [Shadow( color: theme.colorScheme.primary, offset:Offset(1,1), blurRadius: 5)];

    return Container(
      width: tileViewSize,
      height: tileViewSize,
      decoration: BoxDecoration(
        gradient: bgColor,
      ),
      child: Center(
        child: Text(
          symbol,
          style: symbolStyle.copyWith(color: fgColor, fontSize: fontSize, shadows: shadows),
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
    // may not exist if Easy level (only 3 criteria)
    RadialGradient bgColor = _backgroundGradients[(asset.size >3 ? asset.valueAt(3) - 1 : 0)];

    TileView tv = TileView(
      symbol: label,
      fontSize: fontSize,
      fgColor: fgColor,
      bgColor: bgColor,
    );

    return tv;
  }
}
