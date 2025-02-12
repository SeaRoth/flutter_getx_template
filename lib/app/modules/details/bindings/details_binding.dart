import 'package:flutter_getx_template/app/modules/details/controller/details_controller.dart';
import 'package:get/get.dart';

class DetailsBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.put(DetailsController())];
  }
}
