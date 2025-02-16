import 'package:flutter_getx_template/app/helpers/shared_pref_manager.dart';
import 'package:flutter_getx_template/app/modules/our_controller.dart';
import 'package:flutter_getx_template/app/modules/theme_controller.dart';
import 'package:get/get.dart';

class SettingsController extends OurController {
  var settingsText = "settings text from controller".obs;
  final ThemeController themeController = Get.find<ThemeController>();
  //final RxList<int> selectedMatchQueueIds = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
