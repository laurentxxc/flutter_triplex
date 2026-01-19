// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'homepage.dart';
import 'sound_player.dart';

void main() {
  SoundPlayer.init();
  runApp(const TriplexApp());
}

class TriplexApp extends StatelessWidget {
  const TriplexApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Triplex',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mainThemeColor),
        textTheme: GoogleFonts.revaliaTextTheme(Theme.of(context).textTheme),
      ),
      home: const MyHomePage(title: 'Triplex'),
    );
  }
}
