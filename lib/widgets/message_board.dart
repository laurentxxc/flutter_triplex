// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:triplex/generated/app_localizations.dart';

const Widget coffeeLogo = Text('☕️', style: TextStyle(fontSize: 50));
const Widget smileyLogo = Text('😜', style: TextStyle(fontSize: 50));
const Widget winnerLogo = Text('🏆', style: TextStyle(fontSize: 50));
const Widget messageBoardVSpace = SizedBox(height:40.0);


enum MessageType {
  pause(
    textId:'pauseMessage',
    logo: coffeeLogo,
    ),
  gameOver(
    textId:'gameOverMessage',
    logo:smileyLogo
  ),
  bestScore(
    textId: 'gameOverMessageBestScore',
    logo:winnerLogo,
  ),
  none(
    textId:'',
    logo: Text('0'),
  );

  String translate(AppLocalizations l10n) {
    switch (textId) {
      case 'pauseMessage':
        return l10n.pauseMessage;
      case 'gameOverMessage':
        return l10n.gameOverMessage;
      case 'gameOverMessageBestScore':
        return l10n.gameOverMessageBestScore;
      default:
        return 'unknown';
    }
  }
 
  const MessageType({required this.textId, required this.logo}); 
  final String textId;
  final Widget logo;
}

class TriplexBoardMessage extends StatelessWidget {
  final MessageType message;
  final Size size;
  final List<Widget>? extra; // optional list of widgets to add bellow the message, e.g., for sharing best score achievement

  TriplexBoardMessage({
    required this.message,
    this.size = const Size(500,760),
    this.extra = const [],
  });


  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displaySmall!.copyWith(
      fontSize: 21,
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    Widget content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          message.logo,
          messageBoardVSpace,
          Text(
            message.translate(l10n), 
            textAlign: TextAlign.center, 
            style: textStyle,
            softWrap: true,
          ),
          ...extra!,
        ],
      ),
    );

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Card(
        elevation: 20,
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.9),
        margin: const EdgeInsets.all(30),
        child: content,
      ),
    );
  }
}
