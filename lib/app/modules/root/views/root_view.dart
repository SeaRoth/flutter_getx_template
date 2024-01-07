import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/globals.dart';
import 'package:flutter_getx_template/app/models/screen_constants.dart';
import 'package:flutter_getx_template/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../controllers/root_controller.dart';

class RootView extends GetView<RootController> {
  const RootView({super.key});

  void setScreenStuff(BuildContext context) {
    final statusBarHeight = Get.statusBarHeight / context.mediaQuery.devicePixelRatio;
    var screenHeight = returnHeightOfDevice(context);
    var screenWidth = returnWidthOfDevice(context);
    print("statusBarHeight: $statusBarHeight, screenHeight: $screenHeight, screenWidth: $screenWidth");

    var sc = ScreenConstants(statusBarHeight: statusBarHeight, height: screenHeight, width: screenWidth);
    getIt.registerSingleton<ScreenConstants>(sc);
  }

  double returnHeightOfDevice(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double returnWidthOfDevice(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  double returnStatusBarHeight() {
    var screenConstants = GetIt.instance<ScreenConstants>();
    return screenConstants.statusBarHeight;
  }

  @override
  Widget build(BuildContext context) {
    if (!getIt.isRegistered<ScreenConstants>()) {
      setScreenStuff(context);
    }

    // return AutoSizeText("DATA");

    return Scaffold(
        body: GetRouterOutlet(
      initialRoute: Routes.routeHome,
      anchorRoute: '/',
    ));
  }
}
