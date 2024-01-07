import 'package:flutter_getx_template/app/modules/profile/controller/profile_controller.dart';
import 'package:get/get.dart';

class ProfileBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.put(ProfileController())];
  }
}
