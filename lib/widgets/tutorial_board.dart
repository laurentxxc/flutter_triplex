// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'package:flutter/material.dart';
import '../generated/app_localizations.dart';
import '../tile_scheme.dart';
import '../asset_model.dart';

const Widget welcomeLogo = Text('🎉', style: TextStyle(fontSize: 35));
const Widget luckLogo = Text('🍀', style: TextStyle(fontSize: 35));
const Widget goodLogo = Icon(Icons.check_box, size:50, color: Colors.green);
const Widget wrongLogo = Icon(Icons.cancel, size:50, color:Colors.red);
const Widget vSpace = SizedBox(height:20.0);

const bool enableScrolling = true;
const bool showScrollbar = true;

enum TutorialMatchSample {
  good(
    assets: [[1,1,3,1], [1,1,1,2], [1,1,2,3]],
    logo: goodLogo,
    ),
  wrong(
    assets: [[2,1,2,1], [2,1,2,1], [3,1,2,1]],
    logo: wrongLogo,
  );

  const TutorialMatchSample({required this.assets, required this.logo});
  final List<List<int>> assets;
  final Widget logo;
}

Text getText(String text,TextStyle style, {TextAlign align = TextAlign.center}){
  return Text(text, textAlign: align, style: style);
}

Widget getTutorialSampleView(TutorialMatchSample sample, Color borderColor) {
  List<Widget> content = [sample.logo];
  content.addAll(sample.assets.map(
          (assetValues) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all( color:borderColor, width: 10.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: TileView.fromAsset(Asset(values: assetValues))),
          )
        ));

  return SizedBox(
    width: 300,
    child: FittedBox(
      fit: BoxFit.contain,
      child: Row(
        spacing: 10.0,
        children: content,
      ),
    ),
  );
}


class TriplexTutorial extends StatelessWidget {
  final Size size;

  TriplexTutorial({this.size = const Size(500,760)});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!; 
    final theme = Theme.of(context);
    final textStyleHead = theme.textTheme.displaySmall!.copyWith(
      fontSize: 24,
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
    final textStyleCore = theme.textTheme.displaySmall!.copyWith(
      fontSize: 19,
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
    final Color borderColor = theme.colorScheme.primary;
    final Icon lineSep = Icon(Icons.horizontal_rule, size: 50, color: borderColor,);

    Widget content = Column(
      children: [
        // welcome header
        welcomeLogo,        
        getText(l10n.tutorial_welcome,textStyleHead),

        vSpace,
        // tutorial main
        getText(l10n.tutorial_main, textStyleCore, align: TextAlign.left),

        lineSep,
        
        // Example good
        getText(l10n.tutorial_good_title, textStyleHead),
        vSpace,
        getTutorialSampleView(TutorialMatchSample.good, borderColor),
        vSpace,
        getText(l10n.tutorial_good_desc, textStyleCore, align: TextAlign.left),

        lineSep,

        // Example wrong
        getText(l10n.tutorial_wrong_title, textStyleHead),
        vSpace,
        getTutorialSampleView(TutorialMatchSample.wrong, borderColor),
        vSpace,
        getText(l10n.tutorial_wrong_desc, textStyleCore, align: TextAlign.left),

        lineSep,

        // good luck
        getText(l10n.tutorial_final, textStyleHead),
        vSpace,
        luckLogo,
      ],
    );

    // Wrap with scrolling widgets if enabled
    if (enableScrolling) {
      content = SingleChildScrollView(
        primary: true,
        padding: const EdgeInsets.all(16),
        child: content,
      );

      if (showScrollbar) {
        content = Scrollbar(
          // 2026-02-04: using parameter defined in main themeData
          // thumbVisibility: true, // Always show scrollbar thumb
          // trackVisibility: false,
          // thickness: 10, // Scrollbar thickness
          // radius: const Radius.circular(5), // Rounded scrollbar
          child: content,
        );
      }
    }
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Card(
        elevation: 20,
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.9),
        margin: const EdgeInsets.all(30),
        child: content,
      ),
    );
  }
}
