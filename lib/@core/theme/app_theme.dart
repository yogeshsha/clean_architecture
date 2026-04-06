import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF4F46E5),   // Indigo
      secondary: Color(0xFF7C3AED), // Purple
      surface: Color(0xFFF9FAFB),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF111827),
    ),

    scaffoldBackgroundColor: const Color(0xFFF9FAFB),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF4F46E5),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF6366F1),
      secondary: Color(0xFFA78BFA),
      surface: Color(0xFF111827),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
    ),

    scaffoldBackgroundColor: const Color(0xFF030712),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF111827),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}