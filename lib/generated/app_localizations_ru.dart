// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get localeLogo => '🇷🇺';

  @override
  String get localeDesc => 'Русский';

  @override
  String get settingLanguageMenu => 'Язык';

  @override
  String get settingsSoundMenu => 'Звук/Эффекты';

  @override
  String get settingsTutorial => 'Обучение';

  @override
  String get appTitle => 'Triplex';

  @override
  String get startButton => 'Начать';

  @override
  String get pauseButton => 'Пауза';

  @override
  String get resumeButton => 'Продолжить';

  @override
  String get currentScore => 'Текущий счёт';

  @override
  String get timeLeft => 'Времени осталось';

  @override
  String get bestScore => 'Лучший счёт';

  @override
  String get welcomeMessage =>
      '🎉 Добро пожаловать в Triplex 🎉\n\nВ этой игре у вас ограниченное время, чтобы найти соответствующие тройки плиток на основе их атрибутов.\nКаждая плитка имеет разные атрибуты (например, представление, размер, цвет, фон).\n\nВыберите три плитки, чтобы создать соответствие.\n\nУ вас есть действительное соответствие, если для каждого атрибута три плитки либо все одинаковые, либо все разные.\nЦель - найти как можно больше действительных соответствий до истечения времени!\n\nУдачи и приятной игры! 🍀';

  @override
  String get pauseMessage =>
      'Игра приостановлена.\n\nСделайте перерыв ☕️ и продолжите, когда будете готовы.';

  @override
  String get gameOverMessage =>
      'Игра окончена! Время вышло.\n\nПопробуйте побить свой лучший счёт в следующий раз!\n\n😜';

  @override
  String get gameOverMessageBestScore =>
      'Игра окончена! Время вышло.\n\nПоздравляем! В этот раз вы установили лучший счёт.\n\n🎉';
}
