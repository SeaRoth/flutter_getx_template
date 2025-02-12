import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/globals.dart';
import 'package:flutter_getx_template/app/helpers/number_formatter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/modules/theme_controller.dart';
import 'my_app.dart';

void main() async {
  Get.put(ThemeController());
  getIt.registerSingleton<MyNumberFormatter>(MyNumberFormatter());
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init("flutter_template_db");

  try {
    runApp(
      MyApp(),
    );
  } catch (e, stackTrace) {
    print(e.toString());
    print(stackTrace.toString());
  }
}
