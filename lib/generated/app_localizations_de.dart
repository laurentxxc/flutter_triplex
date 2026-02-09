// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get localeLogo => '🇩🇪';

  @override
  String get localeDesc => 'Deutsch';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingLanguageMenu => 'Sprache';

  @override
  String get settingsSoundMenu => 'Ton/Effekte';

  @override
  String get settingsTutorial => 'Tutorial';

  @override
  String get appTitle => 'Triplex';

  @override
  String get startButton => 'Starten';

  @override
  String get pauseButton => 'Pause';

  @override
  String get resumeButton => 'Fortsetzen';

  @override
  String get currentScore => 'Aktueller Punktestand';

  @override
  String get timeLeft => 'Verbleibende Zeit';

  @override
  String get bestScore => 'Bester Punktestand';

  @override
  String get tutorial_welcome => 'Willkommen bei Triplex';

  @override
  String get tutorial_main =>
      'In diesem Spiel haben Sie begrenzte Zeit, um passende Dreiergruppen von Kacheln basierend auf ihren Attributen zu finden.\nJede Kachel hat unterschiedliche Attribute (z.B. Darstellung, Größe, Farbe, Hintergrund).\n\nWählen Sie drei Kacheln, um eine Übereinstimmung zu bilden.\n\nSie haben eine gültige Übereinstimmung, wenn für jedes Attribut die drei Kacheln entweder alle gleich oder alle unterschiedlich sind.\nDas Ziel ist, so viele gültige Übereinstimmungen wie möglich zu finden, bevor die Zeit abläuft!';

  @override
  String get tutorial_good_title => 'Beispiel für eine gültige Übereinstimmung';

  @override
  String get tutorial_good_desc =>
      'Das gleiche Herz-Symbol ist auf allen Kacheln vorhanden. Die Hintergrund- und Symbolfarben sind bei den Kacheln unterschiedlich.';

  @override
  String get tutorial_wrong_title =>
      'Beispiel für eine falsche Übereinstimmung';

  @override
  String get tutorial_wrong_desc =>
      'Das Symbol der mittleren Kachel (Krone) ist dasselbe wie bei der linken Kachel, aber anders als bei der rechten Kachel (Flagge). Die Kachel-Symbole müssen entweder alle gleich oder alle unterschiedlich sein.';

  @override
  String get tutorial_final => 'Viel Glück und haben Sie Spaß!';

  @override
  String get pauseMessage =>
      'Das Spiel ist pausiert.\n\nMachen Sie eine Pause und setzen Sie fort, wenn Sie bereit sind.';

  @override
  String get gameOverMessage =>
      'Spiel beendet! Zeit abgelaufen.\n\nVersuchen Sie, Ihren besten Punktestand beim nächsten Mal zu schlagen.';

  @override
  String get gameOverMessageBestScore =>
      'Spiel beendet! Zeit abgelaufen.\n\nHerzlichen Glückwunsch! Sie haben diesmal den besten Punktestand erreicht.';

  @override
  String get share_button => 'Teile es mit deinen Freunden';

  @override
  String get share_try_url => 'Versuch es selbst unter <<url>> 😜';

  @override
  String get share_achievement_bestScore =>
      'Ich habe gerade einen neuen Best Score bei Triplex erreicht! Kannst du meinen Rekord schlagen? 🏆';
}
