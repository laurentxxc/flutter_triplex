import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('uk'),
  ];

  /// Logo used for the locale
  ///
  /// In en, this message translates to:
  /// **'🇬🇧'**
  String get localeLogo;

  /// Description of the locale
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get localeDesc;

  /// Title for the settings panel
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingLanguageMenu.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingLanguageMenu;

  /// No description provided for @settingsSoundMenu.
  ///
  /// In en, this message translates to:
  /// **'Sound/FX'**
  String get settingsSoundMenu;

  /// No description provided for @settingsTutorial.
  ///
  /// In en, this message translates to:
  /// **'Tutorial'**
  String get settingsTutorial;

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Triplex'**
  String get appTitle;

  /// Text shown on the start game button
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startButton;

  /// Text shown on the pause game button
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseButton;

  /// Text shown on the resume game button
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resumeButton;

  /// Semantic label for current score indicator
  ///
  /// In en, this message translates to:
  /// **'Current score'**
  String get currentScore;

  /// Semantic label for time left indicator
  ///
  /// In en, this message translates to:
  /// **'Time left'**
  String get timeLeft;

  /// Semantic label for best score indicator
  ///
  /// In en, this message translates to:
  /// **'Best score'**
  String get bestScore;

  /// No description provided for @tutorial_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Triplex'**
  String get tutorial_welcome;

  /// No description provided for @tutorial_main.
  ///
  /// In en, this message translates to:
  /// **'In this game, you have limited time to find matching triplets of tiles based on their attributes.\nEach tile has different attributes (e.g. representation, size, color, background).\n\nSelect three tiles to form a match.\n\nYou have a valid match if, for each attribute, the three tiles are either all the same or all different.\nThe goal is to find as many valid matches as possible before time runs out!'**
  String get tutorial_main;

  /// No description provided for @tutorial_good_title.
  ///
  /// In en, this message translates to:
  /// **'Example of valid match'**
  String get tutorial_good_title;

  /// No description provided for @tutorial_good_desc.
  ///
  /// In en, this message translates to:
  /// **'Same single blue heart icon is present on all tiles. Background colors are different across tiles.'**
  String get tutorial_good_desc;

  /// No description provided for @tutorial_wrong_title.
  ///
  /// In en, this message translates to:
  /// **'Example of wrong match'**
  String get tutorial_wrong_title;

  /// No description provided for @tutorial_wrong_desc.
  ///
  /// In en, this message translates to:
  /// **'The middle tile representation icon (crown) is the same as left tile but different from right tile (flag). Tile representation icons must be either all the same or all different.'**
  String get tutorial_wrong_desc;

  /// No description provided for @tutorial_final.
  ///
  /// In en, this message translates to:
  /// **'Good luck and have fun!'**
  String get tutorial_final;

  /// Message shown when game is paused
  ///
  /// In en, this message translates to:
  /// **'The game is paused.\n\nTake a break and resume when you\'re ready!'**
  String get pauseMessage;

  /// Message shown when game ends normally
  ///
  /// In en, this message translates to:
  /// **'Game Over! Time\'s up.\n\nTry to beat your best score next time!'**
  String get gameOverMessage;

  /// Message shown when game ends with new best score
  ///
  /// In en, this message translates to:
  /// **'Game Over! Time\'s up.\n\nCongratulation ! You make the best score this time.'**
  String get gameOverMessageBestScore;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pl',
    'pt',
    'ru',
    'uk',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
