import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/globals.dart';
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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    headerWidget ?? Text(""),
                    Flexible(
                      fit: FlexFit.loose,
                      child: GestureDetector(
                        onTap: () async {
                          Get.back();
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
    barrierColor: Colors.black45,
    backgroundColor: Colors.white60,
    isScrollControlled: true,
    isDismissible: true,
    useRootNavigator: true,
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
