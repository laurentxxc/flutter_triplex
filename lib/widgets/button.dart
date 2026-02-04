// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'package:flutter/material.dart';
import 'package:triplex/generated/app_localizations.dart';

enum TriplexButtonType {
  start(icon: Icons.play_arrow, text: "startButton"),
  resume(icon: Icons.play_arrow, text: "resumeButton"),
  pause(icon: Icons.pause, text: "pauseButton");

  final String text;
  final IconData icon;

  const TriplexButtonType({this.text = '', this.icon = Icons.question_mark});

  String translate(AppLocalizations l10n) {
    switch (text) {
      case 'startButton':
        return l10n.startButton;
      case 'pauseButton':
        return l10n.pauseButton;
      case 'resumeButton':
        return l10n.resumeButton;
      default:
        return text;
    }
  }
}

class TriplexButton extends StatelessWidget {
  final TriplexButtonType type;
  final Function onTap;

  TriplexButton({
    super.key,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final textStyle = theme.textTheme.displaySmall!.copyWith(
      fontSize: 24,
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    return SizedBox(
      height: 50,
      width: 300,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 10,
          side: BorderSide(width: 5, color: theme.colorScheme.primary),
        ),
        onPressed: onTap(),
        child: Row(
          children: [
            Icon(type.icon, size: 40),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  type.translate(l10n),
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum CircleButtonType {
  settings(icon: Icons.settings),
  restart(icon: Icons.replay);

  final IconData icon;
  
  const CircleButtonType({required this.icon});
}

class CircleButton extends StatelessWidget {
  final CircleButtonType type;
  final Function onTap;

  CircleButton({super.key, required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.surfaceContainer,
          side: BorderSide(width: 5, color: theme.colorScheme.primary),
          elevation: 10,
        ),
        onPressed: onTap(),
        child: Icon(type.icon, size: 40, color: theme.colorScheme.primary),
      ),
    );
  }
}
