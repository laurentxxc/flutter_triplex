// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:triplex/generated/app_localizations.dart';
import 'package:triplex/models/achievement_model.dart';
import 'package:triplex/services/achievement_images.dart';

const String shareUrl = 'https://triplex-web.vercel.app';

class ShareService {

  static Future<void> shareAchievement({
    required BuildContext context,
    required Achievement achievement,

  }) async {
    try {
      final AppLocalizations l10n = AppLocalizations.of(context)!;
      // Prepare share text
      final String shareText = _buildShareText(l10n, achievement);
   
      // Generate achievement image
      final Uint8List achievementImage = await AchievementImageService.getAchievementImage(achievement: achievement
      );

      final ShareParams params = ShareParams(
        //subject: 'New Best Score in Triplex!',
        files: [XFile.fromData(achievementImage,mimeType:'image/png', name: 'triplex_${achievement.id.title.replaceAll(' ', '_')}.png')],
        text: shareText,
      );

      // Share with native dialog
      await SharePlus.instance.share(params);
      
      // For debug purpose
      //AchievementImageService.showAchievementPreviewDialog(context, achievementImage);

    } catch (e) {
      debugPrint('Error sharing best score: $e');
      _showErrorSnackBar(context, '$e');
    }
  }

  static String _buildShareText(
    AppLocalizations l10n,
    Achievement achievement,
  ) {
    String res;
    // For now, use a hardcoded message. You can add localization keys later
    switch (achievement.id){
      case AchievementID.bestScore: 
        res = (achievement.timeSinceLastUnlock().inDays < 3) 
        ? l10n.share_achievement_bestScore 
        : l10n.share_achievement_bestScore_old.replaceAll('<<score>>', achievement.criteria['score']?.toString() ?? '0');
       default:
        res =  achievement.id.title;
    }
    res += "\n${l10n.share_try_url.replaceAll('<<url>>', shareUrl)}";
    return res;
  }

  static void _showErrorSnackBar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}