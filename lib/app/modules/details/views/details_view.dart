import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/globals.dart';
import 'package:get/get.dart';

import '../controller/details_controller.dart';

class DetailsView extends GetWidget<DetailsController> {
  const DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoSizeText(
              'Details view',
              maxLines: 1,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Obx(() =>AutoSizeText(
              '${controller.tasksText}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: colorPrimary),
            )),
          ],
        ),
      ),
    );
  }
}
