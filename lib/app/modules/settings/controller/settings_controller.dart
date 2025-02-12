import 'package:flutter_getx_template/app/modules/our_controller.dart';
import 'package:flutter_getx_template/app/modules/theme_controller.dart';
import 'package:get/get.dart';

class SettingsController extends OurController {
  var profileText = "settings text".obs;
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
