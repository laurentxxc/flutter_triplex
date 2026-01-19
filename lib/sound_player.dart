// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'package:audioplayers/audioplayers.dart';

enum Sound{
  tile(soundFileName: 'click.mp3'),
  clock(soundFileName: 'clock.mp3'),
  matchingOK(soundFileName: 'matching_good.mp3'),
  matchingKO(soundFileName: 'matching_wrong.mp3'),
  endingBest(soundFileName: 'ending1.mp3'),
  ending(soundFileName: 'ending2.mp3'),
  volume_off(soundFileName: 'volume_off.mp3'),
  volume_on(soundFileName: 'volume_on.mp3'),
  restart(soundFileName: 'restart.mp3'),
  message(soundFileName: 'message.mp3');

  const Sound({required this.soundFileName});
  final String soundFileName;
}

class SoundPlayer {
  static AudioPlayer player = AudioPlayer();
  static AudioCache cache = AudioCache(prefix: 'sounds/');

  static void init(){
    final List<String> sounds = List.from(Sound.values.map((s) => s.soundFileName));
    cache.loadAll(sounds);
    player.setPlayerMode(PlayerMode.lowLatency);
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
