import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/modules/theme_controller.dart';
import 'app/routes/app_pages.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: "Flutter GetX Template",
        theme: Get.find<ThemeController>().currentTheme.value,
        debugShowCheckedModeBanner: false,
        getPages: AppPages.routes,
        initialRoute: AppPages.initialPageRoute, // Your initial route
      ),
    );
  }
}
