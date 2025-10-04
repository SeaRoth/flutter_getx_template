import 'package:flutter_getx_template/app/modules/loading/loading_controller.dart';
import 'package:flutter_getx_template/app/modules/our_controller.dart';
import 'package:get/get.dart';

class MainController extends OurController {
  final rewardsText = "MainController".obs;

  final loadingController = Get.find<LoadingController>();

  @override
  void onInit() {
    // loadingController.addLoadingModel(LoadingModel(
    //     loadingText: "Loading something",
    //     loadingImage: "loadingImage",
    //     loadingFunctionToRun: () async {
    //       myPrint("Starting async operation...");
    //       await Future.delayed(const Duration(seconds: 2));
    //       myPrint("Async operation completed!");
    //     }));
    //
    // loadingController.addLoadingModel(LoadingModel(
    //     loadingText: "Loading something",
    //     loadingImage: "loadingImage",
    //     loadingFunctionToRun: () async {
    //       myPrint("Starting async operation...");
    //       await Future.delayed(const Duration(seconds: 4));
    //       myPrint("Async operation completed!");
    //     }));
    //
    // loadingController.addLoadingModel(LoadingModel(
    //     loadingText: "Loading something",
    //     loadingImage: "loadingImage",
    //     loadingFunctionToRun: () async {
    //       myPrint("Starting async operation...");
    //       await Future.delayed(const Duration(seconds: 7));
    //       myPrint("Async operation completed!");
    //     }));
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
