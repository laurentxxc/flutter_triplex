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
import '../models/achievement_model.dart';
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
  
  
  // Update single achievement progress
  static Future<void> updateAchievementProgress(
    String title, 
    int newProgress, {
    bool forceUnlock = false,
  }) async {
    try {
      final achievements = await loadAchievements();
      final index = achievements.indexWhere((a) => a.id.title == title);
      
      if (index != -1) {
        final achievement = achievements[index];
        final updatedAchievement = achievement.copyWith(
          //progress: newProgress,
          isUnlocked: forceUnlock || newProgress >= achievement.id.maxProgress,
          unlockedAt: (forceUnlock || newProgress >= achievement.id.maxProgress) 
              ? DateTime.now() 
              : achievement.unlockedAt,
        );
        
        achievements[index] = updatedAchievement;
        await saveAchievements(achievements);
        
        // Return if unlocked for notification purposes
        if (updatedAchievement.isUnlocked && !achievement.isUnlocked) {
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
      Achievement(
        id: AchievementID.bestScore,
        criteria: {'score': 1},
        progress: 0,
        isUnlocked: false,
      ),
    ];
  }
  static void _notifyAchievementUnlocked(Achievement achievement) {
    // This can be integrated with your existing notification system
    print('🏆 Achievement Unlocked: ${achievement.id.title}');
  }
}