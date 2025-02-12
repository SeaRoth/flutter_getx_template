import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../models/screen_constants.dart';

createBottomSheetDialog({required BuildContext context, required Widget contentsWidget, required Widget headerWidget, required double sheetHeightPercentage}) {
  final sc = GetIt.instance<ScreenConstants>();
  final deviceHeight = sc.height;
  double? sheetHeight;
  sheetHeight = deviceHeight * sheetHeightPercentage;

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      height: sheetHeight,
      constraints: BoxConstraints(
        maxHeight: deviceHeight,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 5,
              margin: const EdgeInsets.only(top: 8.0), // Adjust margin as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5 / 2), // Capsule shape
                color: Colors.grey,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    headerWidget,
                    Flexible(
                      fit: FlexFit.loose,
                      child: GestureDetector(
                        onTap: () async {
                          Get.close(closeAll: false);
                        },
                        child: const Icon(
                          Icons.close,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Flexible(
              fit: FlexFit.loose,
              child: SingleChildScrollView(
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                    child: contentsWidget,
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
    isDismissible: true,
    useRootNavigator: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    elevation: 2,
    enterBottomSheetDuration: Duration(milliseconds: 400),
    enableDrag: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
  );
}
