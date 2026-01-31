// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'package:flutter/material.dart';
import '../generated/app_localizations.dart';

const Widget menuSettingSeparator = SizedBox(height:25);

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
  final Function(Locale) onLanguageTap;
  final Function onTutorialTap;
  final bool isSoundOn;

  SettingsPanel({
    required this.size,
    required this.onSoundTap,
    required this.onLanguageTap,
    required this.onTutorialTap,
    required this.isSoundOn,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final menuTextStyle = theme.textTheme.displaySmall!.copyWith(
      fontSize: 20,
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
    final langTextStyle = theme.textTheme.displaySmall!.copyWith(
      fontSize: 16,
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
    final AppLocalizations loc = AppLocalizations.of(context)!;
    
    final GlobalKey<PopupMenuButtonState<Locale>> _popupMenuKey = GlobalKey();

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
              loc.settingsTitle,
              textAlign: TextAlign.center,
              style: menuTextStyle.copyWith(fontSize: 30),
              softWrap: true,
            ),
            
            menuSettingSeparator,
            menuSettingSeparator,
            
            SizedBox(
              width: 300,
              height: 60,
              child: PopupMenuButton<Locale>(
                key: _popupMenuKey,
                position: PopupMenuPosition.over,
                offset: const Offset(40, 30),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: theme.colorScheme.primary),
                  borderRadius: BorderRadius.circular(20.0)
                  ),
                tooltip: '',
                onSelected: (value) {
                  onLanguageTap(value);
                },
                itemBuilder: (context) => createLanguageMenu(langTextStyle),
                child: SettingsButton(
                  leftText: loc.settingLanguageMenu, 
                  rightLogo: Text(loc.localeLogo, style: const TextStyle(fontSize: 25)), 
                  onTap: () {
                    // Programmatically trigger the popup menu
                    _popupMenuKey.currentState?.showButtonMenu();                   
                  }
                  ),
              ),
            ),

            menuSettingSeparator,

            // sounds settings
            SizedBox(
              width: 300,
              height: 60,
              child: SettingsButton(
                leftText: loc.settingsSoundMenu, 
                rightLogo: Icon((isSoundOn) ? Icons.volume_up : Icons.volume_off, size:40, color: theme.colorScheme.primary), 
                onTap: () => onSoundTap(!isSoundOn),
              ),
            ),

            menuSettingSeparator,

           // Tutorial access
            SizedBox(
              width: 300,
              height: 60,
              child: SettingsButton(
                leftText: loc.settingsTutorial, 
                rightLogo: Icon(Icons.help_center, size:40, color: theme.colorScheme.primary), 
                onTap: () => onTutorialTap()
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
    required this.leftText,
    required this.rightLogo,
    required this.onTap, 
  });

  final Function onTap;
  final String leftText;
  final Widget rightLogo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final menuTextStyle = theme.textTheme.displaySmall!.copyWith(
      fontSize: 20,
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    return ElevatedButton(
      onPressed:() => onTap(),
      style: ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.surfaceContainer,
      side: BorderSide(width: 3, color: theme.colorScheme.primary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 10,
    ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              leftText,
              style: menuTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          rightLogo,
        ],
      ),
    );
  }
}
