// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'dart:js_interop';
import 'package:web/web.dart' as web;

class WebAudioPlayer {

  static final audio = web.HTMLAudioElement();

  static Future<void> playSound(String assetPath) async {
    try {
      final webPath = assetPath.startsWith('/assets/')
          ? assetPath
          : '/assets/assets/$assetPath';
      audio.src = webPath;
      await audio.play().toDart; // Convert JS Promise to Dart Future
    } catch (e) {
      print('Modern Web Audio error: $e');
    }
  }
}
