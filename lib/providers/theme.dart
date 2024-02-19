import 'package:bondy/styles.dart';
import 'package:flutter/material.dart';

/// This class represents the theme of the application
class AppTheme extends ChangeNotifier {
  ThemeData get themeData => ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 204, 93)),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: AppStyles.bodyBlack,
        ),
      );
}
