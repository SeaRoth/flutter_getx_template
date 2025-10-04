import 'package:get/get.dart';

class SettingsBinding extends Binding {
  @override
  List<Bind> dependencies() {
    // Settings controller is initialized globally in main.dart as permanent
    // No need to create or bind it here
    return [];
  }
}
