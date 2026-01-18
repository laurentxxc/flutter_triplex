// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'package:flutter/material.dart';

class TriplexButton extends StatelessWidget {
  final IconData buttonSymbol;
  final String buttonText;
  final Function onTap;

  TriplexButton({
    super.key,
    required this.buttonSymbol,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displaySmall!.copyWith(
      fontSize: 24,
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    return SizedBox(
      height: 50,
      width: 250,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 10,
          side: BorderSide(width: 5, color: theme.colorScheme.primary),
        ),
        onPressed: onTap(),
        child: Row(
          children: [
            Icon(buttonSymbol, size: 40),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  buttonText,
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleButton extends StatelessWidget{
  final IconData buttonSymbol;
  final Function onTap;

  CircleButton({
    super.key,
    required this.buttonSymbol,
    required this.onTap
    });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      height:50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.surfaceContainer,
          side: BorderSide(width: 5, color: theme.colorScheme.primary),
          elevation: 10,
        ),
        onPressed: onTap(),
        child: Icon(buttonSymbol,size:40, color:theme.colorScheme.primary),
      ),
    ); 
  }
}
