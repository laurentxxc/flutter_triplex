// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get localeLogo => '🇮🇹';

  @override
  String get localeDesc => 'Italiano';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingLanguageMenu => 'Lingua';

  @override
  String get settingsSoundMenu => 'Audio/Effetti';

  @override
  String get settingsTutorial => 'Tutorial';

  @override
  String get appTitle => 'Triplex';

  @override
  String get startButton => 'Inizia';

  @override
  String get pauseButton => 'Pausa';

  @override
  String get resumeButton => 'Riprendi';

  @override
  String get currentScore => 'Punteggio attuale';

  @override
  String get timeLeft => 'Tempo rimanente';

  @override
  String get bestScore => 'Miglior punteggio';

  @override
  String get welcomeMessage =>
      '🎉 Benvenuti a Triplex 🎉\n\nIn questo gioco, hai un tempo limitato per trovare triplette di tessere corrispondenti in base ai loro attributi. Ogni tessera ha attributi diversi (ad esempio, rappresentazione, dimensione, colore, sfondo).\n\nSeleziona tre tessere per formare una corrispondenza.\n\nHai una corrispondenza valida se, per ogni attributo, le tre tessere sono o tutte uguali o tutte diverse.\nL\'obiettivo è trovare il maggior numero possibile di corrispondenze valide prima che scada il tempo!\n\nBuona fortuna e buon divertimento! 🍀';

  @override
  String get pauseMessage =>
      'Il gioco è in pausa.\n\nPrenditi una pausa ☕️ e riprendi quando sei pronto!';

  @override
  String get gameOverMessage =>
      'Gioco finito! Tempo scaduto.\n\nCerca di battere il tuo miglior punteggio la prossima volta!\n\n😜';

  @override
  String get gameOverMessageBestScore =>
      'Gioco finito! Tempo scaduto.\n\nCongratulazioni! Hai ottenuto il miglior punteggio questa volta.\n\n🎉';
}
