// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'package:flutter/material.dart';
import '../generated/app_localizations.dart';

Widget createLanguageViewItem(AppLocalizations loc, TextStyle style) {
  return Text(
    "${loc.localeLogo}  ${loc.localeDesc}",
    style: style,
    textAlign: TextAlign.center,
  );
}

List<PopupMenuItem<Locale>> createLanguageMenu(TextStyle style) {
  final locales = AppLocalizations.supportedLocales;
  return locales
      .map(
        (locale) => PopupMenuItem(
          value: locale,
          child: createLanguageViewItem(lookupAppLocalizations(locale), style),
        ),
      )
      .toList();
}

class SettingsPanel extends StatelessWidget {
  final Size size;
  final Function(bool) onSoundTap;
  final Function(Locale) onLanguageSelect;
  final Function onTutorialTap;
  final bool isSoundOn;

  SettingsPanel({
    required this.size,
    required this.onSoundTap,
    required this.onLanguageSelect,
    required this.onTutorialTap,
    required this.isSoundOn,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final menuTextStyle = theme.textTheme.displaySmall!.copyWith(
      fontSize: 22,
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
    final langTextStyle = theme.textTheme.displaySmall!.copyWith(
      fontSize: 16,
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
    final AppLocalizations loc = AppLocalizations.of(context)!;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Card(
        elevation: 20,
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.9),
        margin: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              loc.settingLanguageMenu,
              textAlign: TextAlign.center,
              style: menuTextStyle,
              softWrap: true,
            ),
            const SizedBox(height: 10),
            PopupMenuButton<Locale>(
              tooltip: '',
              onSelected: (value) {
                onLanguageSelect(value);
              },
              itemBuilder: (context) => createLanguageMenu(langTextStyle),
              child: Card(
                color: theme.colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(width: 1, color: theme.colorScheme.primary),
                ),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 15,
                  ),
                  child: createLanguageViewItem(loc, langTextStyle),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // sounds settings
            Text(
              loc.settingsSoundMenu,
              textAlign: TextAlign.center,
              style: menuTextStyle,
              softWrap: true,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.volume_off, color: theme.colorScheme.primary),
                Switch(
                  value: isSoundOn,
                  inactiveTrackColor: theme.colorScheme.surfaceContainer,
                  inactiveThumbColor: theme.colorScheme.primary,
                  activeTrackColor: theme.colorScheme.primary,
                  activeThumbColor: theme.colorScheme.surfaceContainer,
                  hoverColor: theme.colorScheme.onPrimary.withAlpha(60),
                  onChanged: (value) {
                    onSoundTap(value);
                  },
                ),
                Icon(Icons.volume_up, color: theme.colorScheme.primary),
              ],
            ),

            const SizedBox(height: 25),

            Text(
              loc.settingsTutorial,
              textAlign: TextAlign.center,
              style: menuTextStyle,
              softWrap: true,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: onTutorialTap(),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primaryContainer,
                side: BorderSide(width: 2, color: theme.colorScheme.primary),
                elevation: 3,
              ),
              child: Icon(
                Icons.help_center,
                size: 29,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        // tutorials
        // Achievements
      ),
    );
  }
}
