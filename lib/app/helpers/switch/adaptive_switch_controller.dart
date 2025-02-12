import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdaptiveSwitchController extends GetxController {
  final String preferenceKey;
  final RxBool switchValue = false.obs;

  AdaptiveSwitchController({required this.preferenceKey, required bool initialValue}) {
    switchValue.value = initialValue;
    loadSwitchState();
  }

  Future<void> loadSwitchState() async {
    final prefs = await SharedPreferences.getInstance();
    switchValue.value = prefs.getBool(preferenceKey) ?? false;
  }

  Future<void> saveSwitchState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(preferenceKey, value);
  }
}
