import 'package:get/get.dart';

import '../controllers/friends_controller.dart';

class FriendsBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<FriendsController>(
        () => FriendsController(),
      )
    ];
  }
}
