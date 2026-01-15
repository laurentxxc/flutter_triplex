// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GameTitle extends StatelessWidget {
  final String title;
  GameTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final titleStyle = theme.textTheme.displaySmall!.copyWith(
      fontSize: 30,
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    final titleSmallStyle = titleStyle.copyWith(fontSize: 10);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: titleStyle),
        Padding(
          padding: const EdgeInsets.only(left:10,bottom:20),
          child: Row(
            children: [
              Text('joyfully made by ', style: titleSmallStyle),
              GestureDetector(
                onTap: () async {
                  const url = 'https://webresume-lxxc.vercel.app';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  }
                },
                child: Text(
                  'L.Vincent',
                  style: titleSmallStyle.copyWith(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
