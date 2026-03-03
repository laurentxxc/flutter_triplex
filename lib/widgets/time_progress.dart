// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'package:flutter/material.dart';
import '../generated/app_localizations.dart';

class TriplexTimeProgressBar extends StatelessWidget {
  final double progress;
  final bool easyModeOn;

  TriplexTimeProgressBar({super.key, required this.progress, required this.easyModeOn});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color textColor =  Color.fromARGB(255, 148, 253, 255);
    final Color shadowColor = theme.colorScheme.primary;
    final AppLocalizations loc = AppLocalizations.of(context)!;

    return Stack(
      children: [ LinearProgressIndicator(
        value: progress, // Example progress value
        minHeight: 30,
        borderRadius: BorderRadius.circular(15),
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
      ),
      if (easyModeOn)
        Positioned.fill(
          child: Text(
            loc.settingsEasyMode,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              shadows: [
                Shadow(color: shadowColor, blurRadius: 4),
                Shadow(color: shadowColor, blurRadius: 6),
                Shadow(color: shadowColor, blurRadius: 10),
              ]
            ),
          ),
        ),
      ],
    );
  }
}
