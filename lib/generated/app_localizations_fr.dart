// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get localeLogo => '🇫🇷';

  @override
  String get localeDesc => 'Français';

  @override
  String get settingLanguageMenu => 'Langue';

  @override
  String get settingsSoundMenu => 'Volume';

  @override
  String get settingsTutorial => 'Tutoriel';

  @override
  String get appTitle => 'Triplex';

  @override
  String get startButton => 'Commencer';

  @override
  String get pauseButton => 'Pause';

  @override
  String get resumeButton => 'Reprendre';

  @override
  String get currentScore => 'Score actuel';

  @override
  String get timeLeft => 'Temps restant';

  @override
  String get bestScore => 'Meilleur score';

  @override
  String get welcomeMessage =>
      '🎉 Bienvenue dans Triplex 🎉\n\nVous avez un temps limité pour trouver des triplets de tuiles correspondantes basées sur leurs attributs.\nChaque tuile a différents attributs (ex: forme, taille, couleur, fond).\n\nSélectionnez trois tuiles pour former une correspondance.\n\nLa correspondance est valide si, pour chaque attribut, les trois tuiles sont soit toutes identiques soit toutes différentes.\nLe but est de trouver autant de correspondances valides que possible avant la fin du temps!\n\nBonne chance et amusez-vous bien! 🍀';

  @override
  String get pauseMessage =>
      'Le jeu est en pause.\n\nPrenez une pause ☕️ et reprenez quand vous êtes prêt!';

  @override
  String get gameOverMessage =>
      'Jeu terminé! Le temps est écoulé.\n\nEssayez de battre votre meilleur score la prochaine fois!\n\n😜';

  @override
  String get gameOverMessageBestScore =>
      'Jeu terminé! Le temps est écoulé.\n\nFélicitations! Vous avez obtenu le meilleur score cette fois-ci.\n\n🎉';
}
