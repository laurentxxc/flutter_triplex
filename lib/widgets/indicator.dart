// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'package:flutter/material.dart';

class TriplexUIIndicator extends StatelessWidget {
  final String uiIndicatorText;
  final IconData uiIndicatorSymbol;
  final String uiSemantic;

  TriplexUIIndicator({
    super.key,
    required this.uiIndicatorText,
    required this.uiIndicatorSymbol,
    required this.uiSemantic,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displaySmall!.copyWith(
      fontSize: 20,
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
        border: BoxBorder.all(
          color: theme.colorScheme.primary,
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: SizedBox(
        width: 150,
        child: Row(
          children: [
            Icon(
              uiIndicatorSymbol,
              size: 40,
              color: theme.colorScheme.primary,
              semanticLabel: 'Current score',
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 8.0),
              child: Text(uiIndicatorText, style: textStyle),
            ),
          ],
        ),
      ),
    );
  }
}
