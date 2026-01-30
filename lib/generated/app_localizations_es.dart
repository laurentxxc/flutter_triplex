// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get localeLogo => '🇪🇸';

  @override
  String get localeDesc => 'Español';

  @override
  String get settingLanguageMenu => 'Idioma';

  @override
  String get settingsSoundMenu => 'Sonido/Efectos';

  @override
  String get settingsTutorial => 'Tutorial';

  @override
  String get appTitle => 'Triplex';

  @override
  String get startButton => 'Empezar';

  @override
  String get pauseButton => 'Pausa';

  @override
  String get resumeButton => 'Reanudar';

  @override
  String get currentScore => 'Puntuación actual';

  @override
  String get timeLeft => 'Tiempo restante';

  @override
  String get bestScore => 'Mejor puntuación';

  @override
  String get welcomeMessage =>
      '🎉 ¡Bienvenido a Triplex! 🎉\n\nEn este juego, tienes tiempo limitado para encontrar tríos de fichas coincidentes basadas en sus atributos.\nCada ficha tiene diferentes atributos (ej: representación, tamaño, color, fondo).\n\nSelecciona tres fichas para formar una coincidencia.\n\nTienes una coincidencia válida si, para cada atributo, las tres fichas son o todas iguales o todas diferentes.\n¡El objetivo es encontrar tantas coincidencias válidas como sea posible antes de que se acabe el tiempo!\n\n¡Buena suerte y diviértete! 🍀';

  @override
  String get pauseMessage =>
      'El juego está en pausa.\n\nToma un descanso ☕️ y reanuda cuando estés listo.';

  @override
  String get gameOverMessage =>
      '¡Juego terminado! Se acabó el tiempo.\n\nIntenta superar tu mejor puntuación la próxima vez.\n\n😜';

  @override
  String get gameOverMessageBestScore =>
      '¡Juego terminado! Se acabó el tiempo.\n\n¡Felicidades! Has conseguido la mejor puntuación esta vez.\n\n🎉';
}
