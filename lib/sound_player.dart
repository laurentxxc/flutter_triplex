// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'package:audioplayers/audioplayers.dart';

enum Sound{
  tile(soundFileName: 'click.wav'),
  clock(soundFileName: 'clock.wav'),
  matchingOK(soundFileName: 'matching_good.wav'),
  matchingKO(soundFileName: 'matching_wrong.wav'),
  endingBest(soundFileName: 'ending1.wav'),
  ending(soundFileName: 'ending2.wav'),
  volume_off(soundFileName: 'volume_off.wav'),
  volume_on(soundFileName: 'volume_on.wav'),
  restart(soundFileName: 'restart.wav'),
  message(soundFileName: 'message.wav');

  const Sound({required this.soundFileName});
  final String soundFileName;
}

class SoundPlayer {
  static AudioPlayer player = AudioPlayer();
  static AudioCache cache = AudioCache(prefix: 'sounds/');

  static void init(){
    final List<String> sounds = List.from(Sound.values.map((s) => s.soundFileName));
    cache.loadAll(sounds);
  }

  static Future<void> play(Sound sound) async {
    final AssetSource src = AssetSource('sounds/${sound.soundFileName}');
    try {
    await player.play(src);
    } catch (e) {
      print('Audio error: $e');
    }
  }
}
