// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

enum AchievementID { 
  bestScore(emoji:'🏆', title:'BEST SCORE', maxProgress: 1,
    description:'Achieve a new best score in a game session.'), 
  hundred(emoji: '💯', title: 'HUNDRED', maxProgress: 100,
    description:'Reach 100 points in a single game session.'),
  addicted(emoji: '🎮', title: 'ADDICTED', maxProgress: 50,
    description:'Play 50 games.'),
  diversity(emoji: '🌈', title: 'DIVERSITY', maxProgress: 4,
    description:'Find 4 different tile sets with no common criteria.'),
  unknown(emoji:'❓', title: 'UNKNOWN', maxProgress: 1,
    description:'An unknown achievement.'); // fallback in case of JSON parsing issues

  // these are fixed for enum value, so don't need to be stored in the achievement instance
  final String title;
  final String emoji;
  final String description;
  final int maxProgress;

  const AchievementID({
    required this.title,
    required this.emoji,
    this.description = '',
    this.maxProgress = 1, // default to 1 for simple achievements
  });
}

class Achievement {
  final AchievementID id;
  final Map<String, dynamic> criteria;
  final int nbTimesUnlocked; // Nb of times the achievement has been unlocked
  final DateTime? unlockedAt;
  final int progress;

  const Achievement({
    required this.id,
    required this.criteria,
    this.nbTimesUnlocked = 0,
    this.unlockedAt,
    this.progress = 0});


 // JSON Serialization
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: AchievementID.values.firstWhere(
        (e) => e.name == json['id'],
        orElse: () => AchievementID.unknown,
      ),
      criteria: Map<String, dynamic>.from(json['criteria'] ?? {}),
      nbTimesUnlocked: json['nbTimesUnlocked'] as int? ?? 0,
      unlockedAt: json['unlockedAt'] != null 
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      progress: json['progress'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.name,
      'criteria': criteria,
      'nbTimesUnlocked': nbTimesUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'progress': progress,
    };
  }

  Duration timeSinceLastUnlock() {
    if (unlockedAt == null) return Duration.zero;
    return DateTime.now().difference(unlockedAt!);
  }

  Achievement copyWith({
  //  String? id,
    String? title,
  //  String? description,
    String? emoji,
    AchievementID? type,
    Map<String, dynamic>? criteria,
    int? nbTimesUnlocked,
    DateTime? unlockedAt,
    int? progress,
    int? maxProgress,
  }) {
    return Achievement(
      id: type ?? id,
      criteria: criteria ?? this.criteria,
      nbTimesUnlocked: nbTimesUnlocked ?? this.nbTimesUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
    );
  }
}