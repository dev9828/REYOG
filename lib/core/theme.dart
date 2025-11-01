import 'package:flutter/material.dart';

class AppTheme {
  static const Color gold = Color(0xFFFFC857);
  static const Color goldDark = Color(0xFFDEAA00);
  static const Color deepGreen = Color(0xFF1F6F61);
  static const Color cardBg = Color(0xFFF7EFD9);

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: gold,
    primaryColor: goldDark,
    colorScheme: ColorScheme.fromSeed(seedColor: goldDark),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
      headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: deepGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    ),
  );
}
