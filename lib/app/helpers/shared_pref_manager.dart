import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsManager {
  static const String _keyPrefix = 'my_app_'; // Add a prefix to avoid key collisions

  Future<void> saveIntList(String key, List<int> intList) async {
    final prefs = await SharedPreferences.getInstance();
    final stringList = intList.map((i) => i.toString()).toList();
    await prefs.setStringList('$_keyPrefix$key', stringList);
  }

  Future<List<int>> getIntList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final stringList = prefs.getStringList('$_keyPrefix$key') ?? [];
    return stringList.map((s) => int.parse(s)).toList();
  }
}

// Example Usage (in a Widget or other Dart code):
// final sharedPrefsManager = SharedPrefsManager();
// final myList = [1, 2, 3, 4, 5];
// await sharedPrefsManager.saveIntList("myIntList", myList);
// final retrievedList = await sharedPrefsManager.getIntList("myIntList");
// print(retrievedList); // Output: [1, 2, 3, 4, 5]