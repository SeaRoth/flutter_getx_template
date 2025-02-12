import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final Rx<ThemeData> currentTheme = ThemeData.dark().obs;

  void changeTheme(ThemeData newTheme) {
    currentTheme.value = newTheme;
    Get.changeTheme(newTheme);
  }

  void toggleTheme() {
    if (currentTheme.value == ThemeData.light()) {
      currentTheme.value = ThemeData.dark();
      Get.changeTheme(ThemeData.dark());
    } else {
      currentTheme.value = ThemeData.light();
      Get.changeTheme(ThemeData.light());
    }
  }

  void changeThemeWithString(String themeName) {
    switch(themeName){
      case 'light':
        currentTheme.value = ThemeData.light();
        Get.changeTheme(ThemeData.light());
        break;
      case 'dark':
        currentTheme.value = ThemeData.dark();
        Get.changeTheme(ThemeData.dark());
        break;
      default:
        currentTheme.value = ThemeData.light();
        Get.changeTheme(ThemeData.light());
    }
  }
}
