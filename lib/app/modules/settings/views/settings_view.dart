import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/constants.dart';
import 'package:flutter_getx_template/app/globals.dart';
import 'package:flutter_getx_template/app/helpers/chip_list/chip_list_view.dart';
import 'package:flutter_getx_template/app/helpers/slider/my_slider_view.dart';
import 'package:flutter_getx_template/app/helpers/switch/adaptive_switch_view.dart';
import 'package:get/get.dart';

import '../controller/settings_controller.dart';

class SettingsView extends GetWidget<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: AutoSizeText(
                'Settings view',
                maxLines: 1,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            Center(
              child: Obx(() => AutoSizeText(
                    controller.settingsText.value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: colorPrimary),
                  )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 0, 0),
              child: AdaptiveSwitchView(
                preferenceKey: MyConstants.sharedPrefUseDarkMode,
                label: 'Dark Mode',
                callback: (bool onOrOff) {
                  if (onOrOff) {
                    controller.themeController.changeThemeWithString('dark');
                  } else {
                    controller.themeController.changeThemeWithString('light');
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 0, 0),
              child: MySliderView(
                  preferenceKey: MyConstants.sharedPrefBottomSheetHeight,
                  label: "Bottom sheet height",
                  callback: (double theValue) {
                    print("Changed to $theValue");
                  }),
            ),
            Text(
              "Chip list with Multiselect",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Center(
              child: ChipListView(
                  multiSelect: true,
                  preferenceKey: "chip_list_with_multiselect",
                  chipNames: ["one", "two", "three"],
                  callback: (List<int> theList) {
                    print(theList);
                  }),
            ),
            Text(
              "Chip list without Multiselect",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Center(
              child: ChipListView(
                  multiSelect: false,
                  preferenceKey: "chip_list_without_multiselect",
                  chipNames: ["one", "two", "three"],
                  callback: (List<int> theList) {
                    print(theList);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
