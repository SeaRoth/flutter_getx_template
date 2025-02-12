import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/globals.dart';
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
          children: [
            AutoSizeText(
              'Settings view',
              maxLines: 1,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Obx(() => AutoSizeText(
                  controller.profileText.value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: colorPrimary),
                )),
            AdaptiveSwitchView(
              preferenceKey: 'settings_dark_mode',
              label: 'Dark Mode',
              callback: (bool onOrOff) {
                print("This was changed to $onOrOff");
                controller.themeController.toggleTheme();
              },
            ),
          ],
        ),
      ),
    );
  }
}
