import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/globals.dart';
import 'package:flutter_getx_template/app/helpers/dialog_helper.dart';
import 'package:get/get.dart';

import '../controller/rewards_controller.dart';

class RewardsView extends GetWidget<RewardsController> {
  const RewardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoSizeText(
              'RewardsView is working',
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
                      return GestureDetector(
                        onTap: () {
                          createBottomSheetDialog(context, headerWidget: AutoSizeText("day"), AutoSizeText("$day"));
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AutoSizeText(day),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
