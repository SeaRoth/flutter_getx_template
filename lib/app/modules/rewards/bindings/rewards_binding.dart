import 'package:flutter_getx_template/app/modules/rewards/controller/rewards_controller.dart';
import 'package:get/get.dart';

class RewardsBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.put(RewardsController())];
  }
}
