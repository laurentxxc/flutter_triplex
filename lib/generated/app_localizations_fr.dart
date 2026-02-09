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
  String get settingsTitle => 'Réglages';

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
  String get tutorial_welcome => 'Bienvenue dans Triplex';

  @override
  String get tutorial_main =>
      'Dans ce jeu, vous avez un temps limité pour trouver des triplets de tuiles correspondantes.\n\nChaque tuile possède différents attributs (ex: forme, taille, couleur, fond).\nSélectionnez trois tuiles pour former une correspondance.\n\nLa correspondance est valide si, pour chaque attribut, les trois tuiles sont soit toutes identiques soit toutes différentes.\nLe but est de trouver autant de correspondances valides que possible avant la fin du temps!';

  @override
  String get tutorial_good_title => 'Exemple de correspondance valide';

  @override
  String get tutorial_good_desc =>
      'La même icône (cœur) est présente sur toutes les tuiles. Les couleurs de fond et d\'icônes sont différentes entre les tuiles.';

  @override
  String get tutorial_wrong_title => 'Exemple de correspondance incorrecte';

  @override
  String get tutorial_wrong_desc =>
      'L\'icône présente sur la tuile du milieu (couronne) est identique à celle de la tuile gauche mais différente de celle sur la tuile droite (drapeau) or les icônes des tuiles doivent être soit toutes identiques, soit toutes différentes.';

  @override
  String get tutorial_final => 'Bonne chance et amusez-vous bien!';

  @override
  String get pauseMessage =>
      'Le jeu est en pause.\n\nPrenez une pause et reprenez quand vous êtes prêt!';

  @override
  String get gameOverMessage =>
      'Jeu terminé! Le temps est écoulé.\n\nEssayez de battre votre meilleur score la prochaine fois!';

  @override
  String get gameOverMessageBestScore =>
      'Jeu terminé! Le temps est écoulé.\n\nFélicitations! Vous avez obtenu le meilleur score cette fois-ci.';

  @override
  String get share_button => 'Partagez avec vos amis';

  @override
  String get share_try_url => 'Essayez vous-même à <<url>> 😜';

  @override
  String get share_achievement_bestScore =>
      'Je viens d\'obtenir un nouveau Best Score sur Triplex! Peux-tu battre mon record ? 🏆';
}
