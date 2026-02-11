// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:triplex/homepage.dart'; // For mainThemeColor
import 'package:triplex/models/achievement_model.dart';
const achievementImageSize = Size(500, 500);



/// Service for generating achievement certificate images
class AchievementService {

  static Map<Achievement, Uint8List> _imageCache = {};

  /// Creates a professional achievement certificate image with gradient background
  static Future<Uint8List> getAchievementImage({
    required Achievement achievement,
  }) async {
    // Check cache first
    if (_imageCache.containsKey(achievement)) {
      return _imageCache[achievement]!;
    }

    // Create picture recorder and canvas
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    
    // Draw achievement certificate
    final painter = AchievementPainter(score: achievement.criteria['score'] ?? 0, date: achievement.unlockedAt ?? DateTime.now());
    painter.paint(canvas, achievementImageSize);
    
    // Convert to PNG bytes
    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(
      achievementImageSize.width.toInt(), 
      achievementImageSize.height.toInt()
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    
    final result = byteData!.buffer.asUint8List();
    _imageCache[achievement] = result; // Cache the generated image
    return result;
  }

  // For debug purpose, display a dialog with the achievement image preview
  static Future<void> showAchievementPreviewDialog(BuildContext context, Achievement achievement) async {
    Uint8List imageBytes = await getAchievementImage(achievement: achievement);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(achievement.id.title),
        content: Container(
          width: 500,
          height: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(imageBytes, fit: BoxFit.contain),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'), // Optional - we have arrow close
          ),
          // ElevatedButton(
          //   onPressed: () => _proceedWithShare(imageBytes),
          //   child: Text('Share'),
          // ),
        ],
      ),
    );
  }
}

/// CustomPainter for drawing achievement certificate
class AchievementPainter extends CustomPainter {
  final int score;
  final DateTime date;
  
  // Color constants
  static const Color _goldStart = Color(0xFFFFD900);
  static const Color _goldEnd = Color(0xFFFFA000);
  static const Color _whiteText = Color(0xFFFFFFFF);
  static const Color _shadowColor = Color(0x40000000);
  
  // Layout constants
  static const double _borderThickness = 20.0;
  static const double _outerBorderRadius = 50.0;
 
  // Fonsize constants
  static const double _bestScoreFontSize = 64.0;
  static const double _titleFontSize = 40.0;
  static const double _dateFontSize = 24.0;
  static const double _brandingFontSize = 30.0;
  static const double _trophyFontSize = 64.0;

  AchievementPainter({
    required this.score,
    required this.date,
  }) : super();
  @override
  void paint(Canvas canvas, Size size) {

    // Draw gold border frame
    _drawBorder(canvas);
    
    // Draw background gradient
    _drawBackground(canvas);
    
    // Draw content elements
    _drawTrophy(canvas);
    _drawTitle(canvas);
    _drawScore(canvas, score);
    _drawDate(canvas, date);
    _drawBranding(canvas);
  }
  @override
  bool shouldRepaint(covariant AchievementPainter oldDelegate) {
    return oldDelegate.score != score || oldDelegate.date != date;
  }
  /// Draws gradient background
  void _drawBackground(Canvas canvas) {
    final Shader radialGradient = ui.Gradient.radial(
      Offset(achievementImageSize.width / 2, achievementImageSize.height / 2),
      achievementImageSize.width * 0.90,
      [
        mainThemeColor.withValues(alpha: 1.0),
        mainThemeColor.withValues(alpha: 0.55),
      ],
      [0.0, 1.0],
    );

    final backgroundPaint = Paint()
      ..shader = radialGradient;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          _borderThickness,
          _borderThickness,
          achievementImageSize.width - 2*_borderThickness,
          achievementImageSize.height - 2*_borderThickness),
        Radius.circular(_outerBorderRadius - _borderThickness)
      ),
      backgroundPaint,
    );
  }
  /// Draws gold border frame
  void _drawBorder(Canvas canvas) {
    // Create gold gradient paint
    final borderPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(achievementImageSize.width, achievementImageSize.height),
        [_goldStart, _goldEnd],
        [0.0, 1.0],
      )
      ..style = PaintingStyle.fill;
    // Draw rounded rectangle border
    canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, achievementImageSize.width, achievementImageSize.height),
      Radius.circular(_outerBorderRadius)),
    borderPaint);
  }
  /// Draws trophy icon at top center
  void _drawTrophy(Canvas canvas) {
    final trophyPainter = TextPainter(
      text: const TextSpan(
        text: '🏆',
        style: TextStyle(
          fontSize: _trophyFontSize,
          fontFamily: 'Apple Color Emoji',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    trophyPainter.layout();
    
    final trophyX = (achievementImageSize.width - trophyPainter.width) / 2;
    final trophyY = 120.0; // Fixed position from top
    
    trophyPainter.paint(canvas, Offset(trophyX, trophyY));
  }
  /// Draws "BEST SCORE" title
  void _drawTitle(Canvas canvas) {
    final TextStyle style = GoogleFonts.revalia().copyWith(
      //color: _goldEnd,
      foreground: Paint()..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(achievementImageSize.width, _titleFontSize),
        [_goldStart, _goldEnd],
        [0.0, 1.0],
      ),
      fontSize: _titleFontSize,
      fontWeight: FontWeight.bold,
      letterSpacing: 2.0,
      shadows: [
        const Shadow(
          color: _shadowColor,
          offset: Offset(4, 4),
          blurRadius: 4,
        ),
      ],
    );
    final titlePainter = TextPainter(
      text: TextSpan(
        text: 'BEST SCORE',
        style: style,
      ),
      textDirection: TextDirection.ltr,
    );
    
    titlePainter.layout();
    
    final titleX = (achievementImageSize.width - titlePainter.width) / 2;
    final titleY = 200.0; // Fixed position from top
    
    titlePainter.paint(canvas, Offset(titleX, titleY));
  }
  /// Draws the achievement score number
  void _drawScore(Canvas canvas, int score) {
    final scorePainter = TextPainter(
      text: TextSpan(
        text: score.toString(),
        style: GoogleFonts.revalia().copyWith(
          color: _whiteText,
          fontSize: _bestScoreFontSize, // Fixed max size
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
          shadows: [
            const Shadow(
              color: _shadowColor,
              offset: Offset(3, 3),
              blurRadius: 6,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    scorePainter.layout();
    
    final scoreX = (achievementImageSize.width - scorePainter.width) / 2;
    final scoreY = achievementImageSize.height / 2 ; // Centered position
    
    scorePainter.paint(canvas, Offset(scoreX, scoreY));
  }
  /// Draws achievement date in ISO format
  void _drawDate(Canvas canvas, DateTime date) {
    final dateString = '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    
    final datePainter = TextPainter(
      text: TextSpan(
        text: dateString,
        style: GoogleFonts.revalia().copyWith(
          color: _whiteText,
          fontSize: _dateFontSize,
          fontWeight: FontWeight.normal,
          shadows: [
            const Shadow(
              color: _shadowColor,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    datePainter.layout();
    
    final dateX = (achievementImageSize.width - datePainter.width) / 2;
    final dateY = achievementImageSize.height - 120.0; // Fixed position from bottom
    
    datePainter.paint(canvas, Offset(dateX, dateY));
  }
  /// Draws app branding at bottom
  void _drawBranding(Canvas canvas) {
    final brandingPainter = TextPainter(
      text: TextSpan(
        text: 'Triplex',
        style: GoogleFonts.revalia().copyWith(
          color: _whiteText,
          fontSize: _brandingFontSize,
          fontWeight: FontWeight.normal,
          shadows: [
            const Shadow(
              color: _shadowColor,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    brandingPainter.layout();
    
    final brandingX = (achievementImageSize.width - brandingPainter.width) / 2;
    final brandingY = 50.0;
    
    brandingPainter.paint(canvas, Offset(brandingX, brandingY));
  }
}