import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistent scroll position manager using SharedPreferences
class ScrollPositionManager extends GetxService {
  static ScrollPositionManager get instance =>
      Get.find<ScrollPositionManager>();

  SharedPreferences? _prefs;

  @override
  Future<void> onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save scroll position persistently
  Future<void> saveScrollPosition(String pageKey, double position) async {
    await _prefs?.setDouble('scroll_$pageKey', position);
  }

  /// Get saved scroll position
  double getScrollPosition(String pageKey) {
    return _prefs?.getDouble('scroll_$pageKey') ?? 0.0;
  }

  /// Clear scroll position for a specific page
  Future<void> clearScrollPosition(String pageKey) async {
    await _prefs?.remove('scroll_$pageKey');
  }

  /// Clear all scroll positions
  Future<void> clearAllScrollPositions() async {
    final keys =
        _prefs?.getKeys().where((key) => key.startsWith('scroll_')).toList() ??
            [];
    for (String key in keys) {
      await _prefs?.remove(key);
    }
  }
}
