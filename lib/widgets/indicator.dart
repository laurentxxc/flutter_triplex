// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'package:flutter/material.dart';
import 'package:triplex/generated/app_localizations.dart';

  String formatTime(int seconds) {
    int min = seconds ~/ 60;
    int sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  String formatScore(int score) {
    if (score >= 0) {
      return score.toString().padLeft(4, '0');
    } else {
      return "-${(score * -1).toString().padLeft(3, '0')}";
    }
  }

enum TriplexUIIndicatorType{
  currentScore(
    icon: Icons.sports_score,
    formatter: formatScore,
    semanticLabel: 'currentScore',
  ),
  timeLeft(
    icon: Icons.timer,
    formatter: formatTime,
    semanticLabel: 'timeLeft',
  ),
  bestScore(
    icon: Icons.emoji_events,
    formatter: formatScore,
    semanticLabel: 'bestScore',
  );

  final IconData icon;
  final String Function(int) formatter;
  final String semanticLabel;

  const TriplexUIIndicatorType({required this.icon, required this.formatter, required this.semanticLabel});

  String getSemantic(AppLocalizations l10n) {
    switch (semanticLabel){
      case 'currentScore':
        return l10n.currentScore;
      case 'timeLeft':
        return l10n.timeLeft;
      case 'bestScore':
        return l10n.bestScore;
      default:
        return '';
    }
  }

}

class TriplexUIIndicator extends StatelessWidget {
  final TriplexUIIndicatorType type;
  final int value;

  TriplexUIIndicator({
    super.key,
    required this.type,
    this.value = 0,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!; 
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
              type.icon,
              size: 40,
              color: theme.colorScheme.primary,
              semanticLabel: type.getSemantic(l10n),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 8.0),
              child: Text(type.formatter(value), style: textStyle),
            ),
          ],
        ),
      ),
    );
  }
}
