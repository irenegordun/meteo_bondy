import 'package:bondy/providers/theme.dart';
import 'package:bondy/providers/weather_provider.dart';
import 'package:bondy/ui/screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      // Provide the theme provider to the entire app
      create: (_) => AppTheme(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(
          // Provide the weather provider to the entire app
          '34892dee8e50ad1f088d6d9a6271c58b&'), // Initialize the weather provider with the API key
      child: const MaterialApp(
        home: SplashScreen(),
      ),
    );
  }
}
