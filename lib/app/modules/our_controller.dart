import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OurController extends FullLifeCycleController with FullLifeCycleMixin {
  /// Service Init
  late SharedPreferences prefs;

  RxList<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
