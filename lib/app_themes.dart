import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[100], // Light background
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.green,
      tertiary: Colors.purple,
      background: Colors.grey,
      surface: Colors.white, // Explicitly set surface to white
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      onBackground: Colors.black,
      onSurface: Colors.black,
    ),
    // ... other light theme properties
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[900], // Dark background
    colorScheme: ColorScheme.dark(
      primary: Colors.blue[200]!,
      secondary: Colors.green[200]!,
      tertiary: Colors.purple[200]!,
      background: Colors.grey[900]!,
      surface: Colors.black, // Explicitly set surface to black
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onTertiary: Colors.black,
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),
    // ... other dark theme properties
  );
}