import 'package:flutter_getx_template/app/modules/settings/controller/settings_controller.dart';
import 'package:get/get.dart';

class SettingsBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.put(SettingsController())];
  }
}
