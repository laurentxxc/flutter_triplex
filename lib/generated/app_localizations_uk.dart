// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get localeLogo => '🇺🇦';

  @override
  String get localeDesc => 'Українська';

  @override
  String get settingLanguageMenu => 'Мова';

  @override
  String get settingsSoundMenu => 'Звук/Ефекти';

  @override
  String get settingsTutorial => 'Посібник';

  @override
  String get appTitle => 'Triplex';

  @override
  String get startButton => 'Почати';

  @override
  String get pauseButton => 'Пауза';

  @override
  String get resumeButton => 'Продовжити';

  @override
  String get currentScore => 'Поточний рахунок';

  @override
  String get timeLeft => 'Часу залишилось';

  @override
  String get bestScore => 'Найкращий рахунок';

  @override
  String get welcomeMessage =>
      '🎉 Ласкаво просимо до Triplex 🎉\n\nУ цій грі ви маєте обмежений час, щоб знайти відповідні трійки плиток на основі їх атрибутів.\nКожна плитка має різні атрибути (наприклад, представлення, розмір, колір, фон).\n\nОберіть три плитки, щоб створити відповідність.\n\nВи маєте дійсну відповідність, якщо для кожного атрибута три плитки або всі однакові, або всі різні.\nМета - знайти якомога більше дійсних відповідей до закінчення часу!\n\nБажаємо удачі та гарно проведіть час! 🍀';

  @override
  String get pauseMessage =>
      'Гра призупинена.\n\nЗробіть перерву ☕️ та продовжте, коли будете готові.';

  @override
  String get gameOverMessage =>
      'Гра закінчена! Час вийшов.\n\nСпробуйте перемогти свій найкращий рахунок наступного разу!\n\n😜';

  @override
  String get gameOverMessageBestScore =>
      'Гра закінчена! Час вийшов.\n\nВітаємо! Цього разу ви встановили найкращий рахунок.\n\n🎉';
}
