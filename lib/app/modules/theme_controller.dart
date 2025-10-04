import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/constants.dart';
import 'package:flutter_getx_template/app_themes.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  final Rx<ThemeData> currentTheme = AppThemes.lightTheme.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    final prefs = await SharedPreferences.getInstance();
    final useDarkMode =
        prefs.getBool(MyConstants.sharedPrefUseDarkMode) ?? false;
    if (useDarkMode) {
      changeThemeWithString("dark");
    } else {
      changeThemeWithString("light");
    }
    super.onReady();
  }

  void changeThemeWithString(String themeName) {
    switch (themeName) {
      case 'light':
        currentTheme.value = AppThemes.lightTheme;
        Get.changeTheme(AppThemes.lightTheme);
        AppThemes.setStatusBarStyle(
            false); // Light mode = dark status bar icons
        break;
      case 'dark':
        currentTheme.value = AppThemes.darkTheme;
        Get.changeTheme(AppThemes.darkTheme);
        AppThemes.setStatusBarStyle(true); // Dark mode = light status bar icons
        break;
      default:
        currentTheme.value = AppThemes.lightTheme;
        Get.changeTheme(AppThemes.lightTheme);
        AppThemes.setStatusBarStyle(false);
    }
    update(); // Notify GetBuilder widgets about the theme change
  }
}
