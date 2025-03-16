import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  final Rx<ThemeData> currentTheme = ThemeData.light().obs;

  @override
  Future<void> onReady() async {
    final prefs = await SharedPreferences.getInstance();
    final useDarkMode = prefs.getBool(MyConstants.sharedPrefUseDarkMode) ?? false;
    if (useDarkMode) {
      changeThemeWithString("dark");
    }else {
      changeThemeWithString("light");
    }
    super.onReady();
  }

  void changeThemeWithString(String themeName) {
    switch (themeName) {
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
