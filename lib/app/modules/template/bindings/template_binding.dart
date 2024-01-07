import 'package:flutter_getx_template/app/modules/template/controller/template_controller.dart';
import 'package:get/get.dart';

class TemplateBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.put(TemplateController())];
  }
}
