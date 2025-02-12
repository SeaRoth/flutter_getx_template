import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_getx_template/app/globals.dart';
import 'package:flutter_getx_template/app/helpers/number_formatter.dart';
import 'package:flutter_getx_template/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  getIt.registerSingleton<MyNumberFormatter>(MyNumberFormatter());
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init("flutter_template_db");

  try {
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    final prefs = await SharedPreferences.getInstance();
    final darkModeUserPreference = prefs.getBool(darkModePref) ?? false;
    late ThemeData selectedThemeData;

    if (darkModeUserPreference) {
      selectedThemeData = ThemeData.dark().copyWith(
        colorScheme: ThemeData().colorScheme.copyWith(
              brightness: Brightness.dark,
              surface: colorSurface,
              onSurface: colorOnPress,
              primary: colorPrimary,
              onPrimary: colorOnPress,
              secondary: colorSecondary,
              onSecondary: colorOnPress,
              error: colorError,
              onError: colorOnPress,
            ),
      );
    } else {
      selectedThemeData = ThemeData.light().copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(
              brightness: Brightness.light,
              primary: Colors.redAccent,
              onPrimary: Colors.purple,
              secondary: colorPrimary,
              onSecondary: Colors.purpleAccent,
              error: Colors.red,
              onError: Colors.red,
              surface: Colors.amber,
              onSurface: Colors.black54));
    }
    runApp(GetMaterialApp(
      title: "Flutter GetX Template",
      theme: selectedThemeData,
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      initialRoute: AppPages.initialPageRoute,
    ));
  } catch (e, stackTrace) {
    print(e.toString());
    print(stackTrace.toString());
  }
}
