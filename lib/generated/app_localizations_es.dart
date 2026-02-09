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
  String get settingsTitle => 'Ajustes';

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
  String get tutorial_welcome => 'Bienvenido a Triplex';

  @override
  String get tutorial_main =>
      'En este juego, tienes tiempo limitado para encontrar tríos de fichas coincidentes basadas en sus atributos.\nCada ficha tiene diferentes atributos (ej: representación, tamaño, color, fondo).\n\nSelecciona tres fichas para formar una coincidencia.\n\nTienes una coincidencia válida si, para cada atributo, las tres fichas son o todas iguales o todas diferentes.\n¡El objetivo es encontrar tantas coincidencias válidas como sea posible antes de que se acabe el tiempo!';

  @override
  String get tutorial_good_title => 'Ejemplo de coincidencia válida';

  @override
  String get tutorial_good_desc =>
      'El mismo icono de corazón está presente en todas las fichas. Los colores de fondo y de icono son diferentes entre las fichas.';

  @override
  String get tutorial_wrong_title => 'Ejemplo de coincidencia incorrecta';

  @override
  String get tutorial_wrong_desc =>
      'El icono de la ficha del medio (corona) es el mismo que la ficha izquierda pero diferente de la ficha derecha (bandera). Los iconos de las fichas deben ser todos iguales o todos diferentes.';

  @override
  String get tutorial_final => '¡Buena suerte y diviértete!';

  @override
  String get pauseMessage =>
      'El juego está en pausa.\n\nToma un descanso y reanuda cuando estés listo.';

  @override
  String get gameOverMessage =>
      '¡Juego terminado! Se acabó el tiempo.\n\nIntenta superar tu mejor puntuación la próxima vez.';

  @override
  String get gameOverMessageBestScore =>
      '¡Juego terminado! Se acabó el tiempo.\n\n¡Felicidades! Has conseguido la mejor puntuación esta vez.';

  @override
  String get share_button => 'Comparte con tus amigos';

  @override
  String get share_try_url => 'Pruébalo tú mismo en <<url>> 😜';

  @override
  String get share_achievement_bestScore =>
      '¡Acabo de conseguir un nuevo Best Score en Triplex! ¿Puedes superar mi récord? 🏆';
}
