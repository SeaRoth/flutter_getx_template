import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final Rx<ThemeData> currentTheme = ThemeData.dark().obs; // Start with a default theme

  void changeTheme(ThemeData newTheme) {
    currentTheme.value = newTheme;
  }

  void toggleTheme() {
    if (currentTheme.value == ThemeData.light()) {
      currentTheme.value = ThemeData.dark();
    } else {
      currentTheme.value = ThemeData.light();
    }
  }

  void changeThemeWithString(String themeName) {
    switch(themeName){
      case 'light':
        currentTheme.value = ThemeData.light();
        break;
      case 'dark':
        currentTheme.value = ThemeData.dark();
        break;
      default:
        currentTheme.value = ThemeData.light();
    }
  }
}
