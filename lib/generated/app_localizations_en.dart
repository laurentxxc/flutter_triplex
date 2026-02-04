// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get localeLogo => '🇬🇧';

  @override
  String get localeDesc => 'English';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingLanguageMenu => 'Language';

  @override
  String get settingsSoundMenu => 'Sound/FX';

  @override
  String get settingsTutorial => 'Tutorial';

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
  String get tutorial_welcome => 'Welcome to Triplex';

  @override
  String get tutorial_main =>
      'In this game, you have limited time to find matching triplets of tiles based on their attributes.\nEach tile has different attributes (e.g. representation, size, color, background).\n\nSelect three tiles to form a match.\n\nYou have a valid match if, for each attribute, the three tiles are either all the same or all different.\nThe goal is to find as many valid matches as possible before time runs out!';

  @override
  String get tutorial_good_title => 'Example of valid match';

  @override
  String get tutorial_good_desc =>
      'Same single heart icon is present on all tiles. Background and icon colors are different across tiles.';

  @override
  String get tutorial_wrong_title => 'Example of wrong match';

  @override
  String get tutorial_wrong_desc =>
      'The middle tile icon (crown) is the same as left tile but different from right tile (flag). Tile icons must be either all the same or all different.';

  @override
  String get tutorial_final => 'Good luck and have fun!';

  @override
  String get pauseMessage =>
      'The game is paused.\n\nTake a break and resume when you\'re ready!';

  @override
  String get gameOverMessage =>
      'Game Over! Time\'s up.\n\nTry to beat your best score next time!';

  @override
  String get gameOverMessageBestScore =>
      'Game Over! Time\'s up.\n\nCongratulation ! You make the best score this time.';
}
