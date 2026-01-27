import 'package:flutter/material.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key, this.onLocaleChanged});

  final Function(Locale)? onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language, color: Colors.white),
      tooltip: 'Change Language',
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const Locale('en'),
          child: Row(
            children: [
              const Text('🇺🇸', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              const Text('English'),
            ],
          ),
        ),
        PopupMenuItem(
          value: const Locale('fr'),
          child: Row(
            children: [
              const Text('🇫🇷', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              const Text('Français'),
            ],
          ),
        ),
      ],
      onSelected: (Locale newLocale) {
        if (onLocaleChanged != null) {
          onLocaleChanged!(newLocale);
        }
      },
    );
  }
}
