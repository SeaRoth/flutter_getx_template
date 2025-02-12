import 'package:flutter_getx_template/app/modules/main/controller/main_controller.dart';
import 'package:get/get.dart';

class MainBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.put(MainController(), permanent: true)];
  }
}
