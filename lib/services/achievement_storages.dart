// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.


// services/achievement_storage.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

import '../models/achievement_model.dart';

const bool debug =
    String.fromEnvironment('DEBUG_ASSETS', defaultValue: 'false') == 'true';

class AchievementStorage {
  static const String _achievementsKey = 'triplex_achievements';
  static const String _statsKey = 'triplex_stats';
  // Save all achievements to localStorage
  static Future<void> saveAchievements(List<Achievement> achievements) async {
    try {
      final SharedPreferences preferences = await SharedPreferences.getInstance();
      
      // Convert achievements to JSON
      final achievementsJson = achievements
          .map((achievement) => achievement.toJson())
          .toList();
      
      // Store as JSON string
      await preferences.setString(_achievementsKey, jsonEncode(achievementsJson));
      print('Successfully saved ${achievements.length} achievements');
    } catch (e) {
      print('Error saving achievements: $e');
    }
  }
  
  
  // Load all achievements from localStorage
  static Future<List<Achievement>> loadAchievements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final achievementsJson = prefs.getString(_achievementsKey);
      
      if (achievementsJson == null) {
        return _getDefaultAchievements(); // Return default achievements
      }
      
      final List<dynamic> decoded = jsonDecode(achievementsJson);
      return decoded
          .map((json) => Achievement.fromJson(json))
          .toList();
    } catch (e) {
      print('Error loading achievements: $e');
      return _getDefaultAchievements(); // Fallback to defaults
    }
  }

  static Future<Achievement?> loadAchievement(AchievementID id) async {
    try {
      final achievements = await loadAchievements();
     final achievement =  achievements.firstWhereOrNull((a) => a.id == id);
      return achievement;
    } catch (e) {
      print('Error loading achievement $id: $e');
      return null;
    }
  }

  static Future<void> updateAchievement(Achievement updatedAchievement) async {
    final achievements = await loadAchievements();
    final index = achievements.indexWhere((a) => a.id == updatedAchievement.id);
    
    if (index != -1) {
      achievements[index] = updatedAchievement;
      await saveAchievements(achievements);
    }
  }
  
  // Update single achievement progress
  static Future<void> updateAchievementProgress(
    AchievementID id, 
    { int newProgress = 0,
      Map<String, dynamic>? criteria,
      bool forceUnlock = false,
  }) async {
    try {
      final achievements = await loadAchievements();
      final index = achievements.indexWhere((a) => a.id == id);
      
      if (index != -1) {
        final achievement = achievements[index];
        final bool isNowUnlocked = forceUnlock || newProgress >= achievement.id.maxProgress;
        final updatedAchievement = achievement.copyWith(
          progress: isNowUnlocked ? 0 : newProgress,
          nbTimesUnlocked: isNowUnlocked ? achievement.nbTimesUnlocked + 1 : achievement.nbTimesUnlocked,
          unlockedAt: (forceUnlock || newProgress >= achievement.id.maxProgress) 
              ? DateTime.now() 
              : achievement.unlockedAt,
          criteria: criteria ?? achievement.criteria,
        );
        
        achievements[index] = updatedAchievement;
        await saveAchievements(achievements);
        
        // Return if unlocked for notification purposes
        if (isNowUnlocked) {
          _notifyAchievementUnlocked(updatedAchievement);
        }
      }
    } catch (e) {
      print('Error updating achievement progress: $e');
    }
  }
  // Get achievement statistics
  static Future<Map<String, dynamic>> getAchievementStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final statsJson = prefs.getString(_statsKey);
      
      if (statsJson != null) {
        return Map<String, dynamic>.from(jsonDecode(statsJson));
      }
    } catch (e) {
      print('Error loading achievement stats: $e');
    }
    
    return {
      'totalMatches': 0,
      'totalScore': 0,
      'bestStreak': 0,
      'fastestMatch': null,
      'gamesPlayed': 0,
    };
  }
  // Update achievement statistics
  static Future<void> updateStats(Map<String, dynamic> newStats) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentStats = await getAchievementStats();
      
      // Merge stats with priority to new values
      final mergedStats = {
        ...currentStats,
        ...newStats,
      };
      
      await prefs.setString(_statsKey, jsonEncode(mergedStats));
    } catch (e) {
      print('Error updating achievement stats: $e');
    }
  }
  // Clear all achievements (for reset functionality)
  static Future<void> clearAchievements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_achievementsKey);
      await prefs.remove(_statsKey);
      print('Achievements cleared successfully');
    } catch (e) {
      print('Error clearing achievements: $e');
    }
  }
  // Default achievements setup
  static List<Achievement> _getDefaultAchievements() {
    return [
      // nothing to return, there is no achievements except for debug purpose
      // if (debug) Achievement(
      //   id: AchievementID.bestScore,
      //   criteria: {'score': 10},
      //   progress: 0,
      //   nbTimesUnlocked: 1,
      //   unlockedAt: DateTime.parse('2024-01-01T00:00:00Z'),
      // ),
    ];
  }
  static void _notifyAchievementUnlocked(Achievement achievement) {
    // This can be integrated with your existing notification system
    print('🏆 Achievement Unlocked: ${achievement.id.title}');
  }
}