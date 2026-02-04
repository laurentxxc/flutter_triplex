// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get localeLogo => '🇵🇱';

  @override
  String get localeDesc => 'Polski';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get settingLanguageMenu => 'Język';

  @override
  String get settingsSoundMenu => 'Dźwięk/Efekty';

  @override
  String get settingsTutorial => 'Samouczek';

  @override
  String get appTitle => 'Triplex';

  @override
  String get startButton => 'Rozpocznij';

  @override
  String get pauseButton => 'Pauza';

  @override
  String get resumeButton => 'Wznów';

  @override
  String get currentScore => 'Aktualny wynik';

  @override
  String get timeLeft => 'Pozostały czas';

  @override
  String get bestScore => 'Najlepszy wynik';

  @override
  String get tutorial_welcome => 'Witaj w Triplex';

  @override
  String get tutorial_main =>
      'W tej grze masz ograniczony czas na znalezienie pasujących trójek kafelków na podstawie ich atrybutów.\nKażdy kafelek ma różne atrybuty (np. reprezentacja, rozmiar, kolor, tło).\n\nWybierz trzy kafelki, aby utworzyć dopasowanie.\n\nMasz prawidłowe dopasowanie, jeśli dla każdego atrybutu trzy kafelki są albo wszystkie takie same, albo wszystkie różne.\nCelem jest znalezienie jak największej liczby prawidłowych dopasowań przed upływem czasu!';

  @override
  String get tutorial_good_title => 'Przykład prawidłowego dopasowania';

  @override
  String get tutorial_good_desc =>
      'Ta sama ikona serca jest obecna na wszystkich kafelkach. Kolory tła i ikon są różne między kafelkami.';

  @override
  String get tutorial_wrong_title => 'Przykład nieprawidłowego dopasowania';

  @override
  String get tutorial_wrong_desc =>
      'Ikona środkowego kafelka (korona) jest taka sama jak lewego kafelka, ale różna od prawego kafelka (flaga). Ikony kafelków muszą być albo wszystkie takie same, albo wszystkie różne.';

  @override
  String get tutorial_final => 'Powodzenia i baw się dobrze!';

  @override
  String get pauseMessage =>
      'Gra jest wstrzymana.\n\nZrób przerwę i wznów, gdy będziesz gotowy.';

  @override
  String get gameOverMessage =>
      'Koniec gry! Czas minął.\n\nSpróbuj pobić swój najlepszy wynik następnym razem!';

  @override
  String get gameOverMessageBestScore =>
      'Koniec gry! Czas minął.\n\nGratulacje! Tym razem uzyskałeś najlepszy wynik.';
}
