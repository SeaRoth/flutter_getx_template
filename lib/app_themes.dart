import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[100], // Light gray background
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // Dark icons for light mode
        statusBarBrightness: Brightness.light,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.green,
      tertiary: Colors.purple,
      surface: Colors.white, // Explicitly set surface to white
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      onSurface: Colors.black,
    ),
    // ... other light theme properties
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[900], // Dark gray background
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // Light icons for dark mode
        statusBarBrightness: Brightness.dark,
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.blue[200]!,
      secondary: Colors.green[200]!,
      tertiary: Colors.purple[200]!,
      surface: Colors.black, // Explicitly set surface to black
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onTertiary: Colors.black,
      onSurface: Colors.white,
    ),
    // ... other dark theme properties
  );

  // Helper method to apply status bar style
  static void setStatusBarStyle(bool isDarkMode) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
    );
  }
}
