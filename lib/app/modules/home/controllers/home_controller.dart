import 'dart:async';

import 'package:flutter_getx_template/app/modules/theme_controller.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final ThemeController themeController = Get.find<ThemeController>();
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    themeController.changeThemeWithString("dark");
  }
}
