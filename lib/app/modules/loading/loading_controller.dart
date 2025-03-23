import 'package:flutter_getx_template/app/helpers/print_debug/build_print.dart';
import 'package:get/get.dart';

import 'loading_model.dart';

class LoadingController extends GetxController {
  final loadingModelList = <LoadingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to changes in loadingModelList
    ever(loadingModelList, (List<LoadingModel> list) {
      if (list.isNotEmpty) {
        final firstLoadingModel = list.first;
        firstLoadingModel.loadingFunctionToRun?.call().then((value) {
          myPrint("During Execution");
        }).whenComplete(() {
          myPrint("finished execution");
          loadingModelList.remove(firstLoadingModel);
        });
      }
    });
  }

  void addLoadingModel(LoadingModel model) {
    loadingModelList.add(model);
  }

  @override
  void onReady() {
    super.onReady();
    myPrint("Controller ready");
  }

  @override
  void onClose() {
    super.onClose();
    myPrint("Controller closed");
  }
}
