import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/constants.dart';
import 'package:flutter_getx_template/app/globals.dart';
import 'package:flutter_getx_template/app/helpers/bottom_sheet_helper.dart';
import 'package:flutter_getx_template/app/helpers/button_template.dart';
import 'package:flutter_getx_template/app/helpers/chip_list/chip_list_view.dart';
import 'package:flutter_getx_template/app/helpers/our_divider.dart';
import 'package:flutter_getx_template/app/helpers/slider/my_slider_view.dart';
import 'package:flutter_getx_template/app/helpers/switch/adaptive_switch_view.dart';
import 'package:flutter_getx_template/app/modules/loading/loading_controller.dart';
import 'package:flutter_getx_template/app/modules/loading/loading_model.dart';
import 'package:flutter_getx_template/app/modules/user_profile/views/user_profile_view.dart';
import 'package:flutter_getx_template/app/modules/user_profile/bindings/user_profile_binding.dart';
import 'package:get/get.dart';

import '../../../helpers/print_debug/build_print.dart';
import '../controller/settings_controller.dart';

class SettingsView extends GetWidget<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: AutoSizeText(
                  'Settings view 🔥 Hot Reload Test!',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              Center(
                child: Obx(() => AutoSizeText(
                      controller.settingsText.value,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: colorPrimary),
                    )),
              ),
              returnOurDivider(context: context),
              Row(
                children: [
                  Text(
                    "Dark Mode",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  AdaptiveSwitchView(
                    preferenceKey: MyConstants.sharedPrefUseDarkMode,
                    callback: (bool onOrOff) {
                      if (onOrOff) {
                        controller.themeController
                            .changeThemeWithString('dark');
                      } else {
                        controller.themeController
                            .changeThemeWithString('light');
                      }
                    },
                  ),
                ],
              ),
              returnOurDivider(context: context),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Bottom sheet height",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: returnButtonCenter(
                          context: context,
                          buttonText: "Show Bottom Sheet",
                          onClick: () {
                            createBottomSheetDialog(
                                context: context,
                                headerWidget: AutoSizeText("Title"),
                                contentsWidget: AutoSizeText("Body"));
                          }),
                    ),
                  )
                ],
              ),
              MySliderView(
                  preferenceKey: MyConstants.sharedPrefBottomSheetHeight,
                  callback: (double theValue) {
                    myPrint("Changed to $theValue");
                  }),
              returnOurDivider(context: context),
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
                      myPrint(theList.toString());
                    }),
              ),
              returnOurDivider(context: context),
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
                      myPrint(theList.toString());
                    }),
              ),
              returnOurDivider(context: context),
              Text(
                "Loading Module Test",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final loadingController = Get.find<LoadingController>();
                    loadingController.addLoadingModel(
                      LoadingModel(
                        loadingText: "Testing loading module for 5 seconds...",
                        loadingImage: "",
                        loadingFunctionToRun: () async {
                          // Simulate a 5-second operation
                          await Future.delayed(const Duration(seconds: 5));
                        },
                      ),
                    );
                  },
                  child: const Text("Show Loading for 5 seconds"),
                ),
              ),
              returnOurDivider(context: context),
              Text(
                "User Profile Module",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Initialize the binding and navigate to User Profile
                    UserProfileBinding().dependencies();
                    Get.to(() => const UserProfileView());
                  },
                  child: const Text("Open User Profile"),
                ),
              ),
              returnOurDivider(context: context),
            ],
          ),
        ),
      ),
    );
  }
}
