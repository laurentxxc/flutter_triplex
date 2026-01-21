// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

    Future<String> _getAppVersion() async {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version; // e.g., "1.0.0"
    }

    return FutureBuilder<String>(
      future: _getAppVersion(),
      builder: (context, snapshot) {
        final version = snapshot.data ?? 'x.y.z';
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: titleStyle),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:7),
                Row(
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
                SizedBox(height: 10),
                Text("v$version", style: titleSmallStyle),
              ],
            ),
          ],
        );
      }
    );
  }
}
