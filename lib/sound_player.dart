// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'web_audio.dart';
import 'package:web/web.dart' as web;

enum Sound {
  tile(soundFileName: 'sounds/click.mp3'),
  clock(soundFileName: 'sounds/clock.mp3'),
  matchingOK(soundFileName: 'sounds/matching_good.mp3'),
  matchingKO(soundFileName: 'sounds/matching_wrong.mp3'),
  endingBest(soundFileName: 'sounds/ending1.mp3'),
  ending(soundFileName: 'sounds/ending2.mp3'),
  volume_off(soundFileName: 'sounds/volume_off.mp3'),
  volume_on(soundFileName: 'sounds/volume_on.mp3'),
  restart(soundFileName: 'sounds/restart.mp3'),
  message(soundFileName: 'sounds/message.mp3');

  const Sound({required this.soundFileName});
  final String soundFileName;
}

class SoundPlayer {
  static AudioPlayer player = AudioPlayer();
  static AudioCache cache = AudioCache();

  static void init() {
    final List<String> sounds = List.from(
      Sound.values.map((s) => s.soundFileName),
    );
    cache.loadAll(sounds);
    player.setPlayerMode(PlayerMode.lowLatency);
  }

  static Future<void> play(Sound sound) async {
    if (kIsWeb && web.window.navigator.userAgent.contains('Safari')) {
      await WebAudioPlayer.playSound(sound.soundFileName);
    } else {
      final AssetSource src = AssetSource(sound.soundFileName);
      try {
        await player.play(src);
      } catch (e) {
        print('Audio error: $e');
      }
    }
  }
}
