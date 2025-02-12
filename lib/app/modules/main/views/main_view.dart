import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/globals.dart';
import 'package:flutter_getx_template/app/helpers/bottom_sheet_helper.dart';
import 'package:get/get.dart';

import '../controller/main_controller.dart';

class MainView extends GetWidget<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoSizeText(
              'Main View',
              maxLines: 1,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Obx(() => AutoSizeText(
                  controller.rewardsText.value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: colorPrimary),
                )),
            Obx(() => Visibility(
                  visible: controller.daysOfWeek.isNotEmpty,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.black38),
                    physics: const ClampingScrollPhysics(),
                    itemCount: controller.daysOfWeek.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var day = controller.daysOfWeek[index];
                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                createBottomSheetDialog(
                                    context: context, headerWidget: AutoSizeText("day"), contentsWidget: AutoSizeText(day));
                              },
                              child: Padding(
                                // Add padding for better touch area
                                padding: const EdgeInsets.all(8.0),
                                child: Text(day),
                              ),
                            ),
                          ),
                          // Other widgets in the row
                        ],
                      );
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
