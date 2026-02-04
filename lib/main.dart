// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';
import 'sound_player.dart';
import 'generated/app_localizations.dart';

void main() {
  SoundPlayer.init();
  runApp(const TriplexApp());
}

class TriplexApp extends StatefulWidget {
  const TriplexApp({super.key});

  @override
  State<TriplexApp> createState() => _TriplexAppState();
}

class _TriplexAppState extends State<TriplexApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      setState(() {
        _locale = Locale(languageCode);
      });
    }
  }

  Future<void> _setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    setState(() {
      _locale = locale;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialApp(
      title: 'Triplex',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mainThemeColor),
        textTheme: GoogleFonts.revaliaTextTheme(theme.textTheme),
        scrollbarTheme: ScrollbarThemeData(
          thickness: WidgetStateProperty.all(14.0),
          thumbColor: WidgetStateProperty.all(theme.colorScheme.primary.withAlpha(150)),
          thumbVisibility: WidgetStateProperty.all(true),
          //trackVisibility: WidgetStateProperty.all(true),
          trackBorderColor: WidgetStateProperty.all(theme.colorScheme.surfaceContainer),
          radius: const Radius.circular(8),
        ),
      ),
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      localeResolutionCallback: (locale, supportedLocales) {
        if (_locale != null) return _locale;
        if (locale != null) {
          for (var supportedLocale in supportedLocales) {
            if (locale.languageCode == supportedLocale.languageCode) {
              return supportedLocale;
            }
          }
        }
        return supportedLocales.first;
      },
      home: MyHomePage(title: 'Triplex', onLocaleChanged: _setLocale,),
    );
  }
}
