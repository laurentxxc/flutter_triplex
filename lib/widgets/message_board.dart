// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'package:flutter/material.dart';

class TriplexBoardMessage extends StatelessWidget {
  final String message;
  final Size size;

  TriplexBoardMessage({required this.message, required this.size});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displaySmall!.copyWith(
      fontSize: 22,
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Card(
        elevation: 20,
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.9),
        margin: const EdgeInsets.all(30),
        child: Center(
          child: Text(message, textAlign: TextAlign.center, style: textStyle),
        ),
      ),
    );
  }
}
