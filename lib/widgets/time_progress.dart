// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'package:flutter/material.dart';

class TriplexTimeProgressBar extends StatelessWidget {
  final double progress;
  TriplexTimeProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress, // Example progress value
      minHeight: 30,
      borderRadius: BorderRadius.circular(15),
    );
  }
}
