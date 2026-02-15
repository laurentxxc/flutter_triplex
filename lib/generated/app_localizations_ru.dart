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
  String get settingsTitle => 'Настройки';

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
  String get tutorial_welcome => 'Добро пожаловать в Triplex';

  @override
  String get tutorial_main =>
      'В этой игре у вас ограниченное время, чтобы найти соответствующие тройки плиток на основе их атрибутов.\nКаждая плитка имеет разные атрибуты (например, представление, размер, цвет, фон).\n\nВыберите три плитки, чтобы создать соответствие.\n\nУ вас есть действительное соответствие, если для каждого атрибута три плитки либо все одинаковые, либо все разные.\nЦель - найти как можно больше действительных соответствий до истечения времени!';

  @override
  String get tutorial_good_title => 'Пример верного соответствия';

  @override
  String get tutorial_good_desc =>
      'Одна и та же иконка сердца присутствует на всех плитках. Цвета фона и иконок различаются между плитками.';

  @override
  String get tutorial_wrong_title => 'Пример неверного соответствия';

  @override
  String get tutorial_wrong_desc =>
      'Иконка средней плитки (корона) такая же, как у левой плитки, но отличается от правой (флаг). Иконки плиток должны быть либо все одинаковые, либо все разные.';

  @override
  String get tutorial_final => 'Удачи и приятной игры!';

  @override
  String get pauseMessage =>
      'Игра приостановлена.\n\nСделайте перерыв и продолжите, когда будете готовы.';

  @override
  String get gameOverMessage =>
      'Игра окончена! Время вышло.\n\nПопробуйте побить свой лучший счёт в следующий раз!';

  @override
  String get gameOverMessageBestScore =>
      'Игра окончена! Время вышло.\n\nПоздравляем! В этот раз вы установили лучший счёт.';

  @override
  String get share_button => 'Поделиться с друзьями';

  @override
  String get share_try_url => 'Попробуйте сами на <<url>> 😜';

  @override
  String get share_achievement_bestScore =>
      'Я только что получил новый Best Score в Triplex! Можете побить мой рекорд? 🏆';

  @override
  String get share_achievement_bestScore_old =>
      '<<score>> - мой лучший результат в Triplex! Попробуй побить! 🏆';
}
