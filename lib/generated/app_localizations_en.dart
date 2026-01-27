// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Triplex';

  @override
  String get startButton => 'Start';

  @override
  String get pauseButton => 'Pause';

  @override
  String get resumeButton => 'Resume';

  @override
  String get currentScore => 'Current score';

  @override
  String get timeLeft => 'Time left';

  @override
  String get bestScore => 'Best score';

  @override
  String get welcomeMessage =>
      '🎉 Welcome to Triplex 🎉\n\nIn this game, you have limited time to find matching triplets of tiles based on their attributes.\nEach tile has different attributes (e.g. representation, size, color, background).\n\nSelect three tiles to form a match.\n\nYou have a valid match if, for each attribute, the three tiles are either all the same or all different.\nThe goal is to find as many valid matches as possible before time runs out!\n\nGood luck and have fun! 🍀';

  @override
  String get pauseMessage =>
      'The game is paused.\n\nTake a break ☕️ and resume when you\'re ready!';

  @override
  String get gameOverMessage =>
      'Game Over! Time\'s up.\n\nTry to beat your best score next time!\n\n😜';

  @override
  String get gameOverMessageBestScore =>
      'Game Over! Time\'s up.\n\nCongratulation ! You make the best score this time.\n\n🎉';
}
