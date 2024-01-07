import 'dart:async';

import 'package:get/get.dart';

class HomeController extends GetxController {
  var finishedLeagueInit = false.obs;

  @override
  Future<void> onInit() async {
    Timer(const Duration(seconds: 3), () {
      finishedLeagueInit.value = true;
    });
    super.onInit();
  }
}
