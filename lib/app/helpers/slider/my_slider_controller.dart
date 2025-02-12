import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySliderController extends GetxController {
  final String preferenceKey;
  final RxDouble sliderValue = 0.0.obs;
  final RxDouble sliderMinimumValue = 0.0.obs;
  final RxDouble sliderMaximumValue = 100.0.obs;

  MySliderController({required this.preferenceKey, required double initialValue, required double minimumValue, required double maximumValue}) {
    sliderValue.value = initialValue;
    sliderMinimumValue.value = minimumValue;
    sliderMaximumValue.value = maximumValue;
    loadSwitchState();
  }

  Future<void> loadSwitchState() async {
    final prefs = await SharedPreferences.getInstance();
    sliderValue.value = prefs.getDouble(preferenceKey) ?? 0.0;
  }

  Future<void> saveSwitchState(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(preferenceKey, value);
  }
}