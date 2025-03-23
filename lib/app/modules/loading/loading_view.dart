import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/globals.dart';
import 'package:flutter_getx_template/app/modules/loading/loading_controller.dart';
import 'package:get/get.dart';

class LoadingView extends GetView<LoadingController> {
  const LoadingView({super.key});

  @override
  LoadingController get controller => Get.put(LoadingController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Obx(() => Visibility(
          visible: controller.loadingModelList.isNotEmpty,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    width: width/1.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Get.theme.colorScheme.surfaceContainer,
                      border: Border.all(
                        color: Colors.white10,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(child: Text("Loading", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.red)),),
                        ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: controller.loadingModelList.length,
                            itemBuilder: (context, indexTopStats) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                    border: Border.all(
                                      color: Colors.white10,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Visibility(visible: indexTopStats == 0, child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator())),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
                                        child: Text(controller.loadingModelList[indexTopStats].loadingText),
                                      )],
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
