import 'package:flutter/material.dart';

class AppTheme {
  // Common Colors
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightCardColor = Colors.white;
  static const Color lightTextColor = Colors.black87;

  static const Color darkBackground = Color(0xFF1E1E2C);
  static const Color darkCardColor = Color(0xFF2D2D44);
  static const Color darkTextColor = Colors.white;

  // 1. Classic Light
  static const Color classicPrimary = Color(0xFF667EEA);
  static const Color classicSecondary = Color(0xFF764BA2);

  // 3. Emerald
  static const Color emeraldPrimary = Color(0xFF11998E);
  static const Color emeraldSecondary = Color(0xFF38EF7D);

  // 4. Sunset
  static const Color sunsetPrimary = Color(0xFFFF512F);
  static const Color sunsetSecondary = Color(0xFFDD2476);

  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    bg: lightBackground,
    card: lightCardColor,
    text: lightTextColor,
    primary: classicPrimary,
    secondary: classicSecondary,
  );

  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    bg: darkBackground,
    card: darkCardColor,
    text: darkTextColor,
    primary: classicPrimary,
    secondary: classicSecondary,
  );

  static ThemeData get emeraldTheme => _buildTheme(
    brightness: Brightness.light,
    bg: const Color(0xFFF1F8F6), // Slightly greenish light background
    card: Colors.white,
    text: Colors.black87,
    primary: emeraldPrimary,
    secondary: emeraldSecondary,
  );

  static ThemeData get sunsetTheme => _buildTheme(
    brightness: Brightness.light,
    bg: const Color(0xFFFFF7F5), // Slightly warm light background
    card: Colors.white,
    text: Colors.black87,
    primary: sunsetPrimary,
    secondary: sunsetSecondary,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color bg,
    required Color card,
    required Color text,
    required Color primary,
    required Color secondary,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: primary,
      scaffoldBackgroundColor: bg,
      cardColor: card,
      appBarTheme: AppBarTheme(
        backgroundColor: card,
        foregroundColor: text,
        elevation: 1,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: text),
        bodyMedium: TextStyle(color: text),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: brightness,
        primary: primary,
        secondary: secondary,
        surface: card,
        onSurface: text,
      ),
    );
  }
}
