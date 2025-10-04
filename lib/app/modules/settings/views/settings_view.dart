import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/constants.dart';
import 'package:flutter_getx_template/app/globals.dart';
import 'package:flutter_getx_template/app/helpers/bottom_sheet_helper.dart';
import 'package:flutter_getx_template/app/helpers/button_template.dart';
import 'package:flutter_getx_template/app/helpers/app_chip.dart';
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
    // State for AppChip demos
    final RxList<int> appChipSelection = <int>[0].obs;
    final RxInt choiceSelection = 1.obs; // For choice chips
    final RxInt sizeSelection =
        0.obs; // For size chips (0=small, 1=medium, 2=large)

    // Trigger scroll restoration when view builds (e.g., when navigating back)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.onViewResumed();
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: controller.scrollController,
          key: const PageStorageKey<String>('settings_scroll'),
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
                "New AppChip Design System",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                "Filter Chips (Multi-select):",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Obx(() => AppChipGroup(
                    labels: const [
                      "Design",
                      "Development",
                      "Marketing",
                      "Sales"
                    ],
                    selectedIndices: appChipSelection.toList(),
                    multiSelect: true,
                    type: AppChipType.filter,
                    size: AppChipSize.medium,
                    onSelectionChanged: (indices) {
                      appChipSelection.assignAll(indices);
                      myPrint("AppChip selection: $indices");
                    },
                  )),
              const SizedBox(height: 12),
              Text(
                "Choice Chips (Single select):",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Obx(() => AppChipGroup(
                    labels: const ["Beginner", "Intermediate", "Advanced"],
                    selectedIndices: [choiceSelection.value],
                    multiSelect: false,
                    type: AppChipType.choice,
                    size: AppChipSize.medium,
                    onSelectionChanged: (indices) {
                      if (indices.isNotEmpty) {
                        choiceSelection.value = indices.first;
                        myPrint("Choice selection: ${indices.first}");
                      }
                    },
                  )),
              const SizedBox(height: 12),
              Text(
                "Different Sizes:",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Obx(() => Row(
                    children: [
                      AppChip(
                        label: "Small",
                        size: AppChipSize.small,
                        type: AppChipType.filter,
                        isSelected: sizeSelection.value == 0,
                        onTap: () {
                          sizeSelection.value = 0;
                          myPrint("Small chip selected");
                        },
                      ),
                      const SizedBox(width: 8),
                      AppChip(
                        label: "Medium",
                        size: AppChipSize.medium,
                        type: AppChipType.filter,
                        isSelected: sizeSelection.value == 1,
                        onTap: () {
                          sizeSelection.value = 1;
                          myPrint("Medium chip selected");
                        },
                      ),
                      const SizedBox(width: 8),
                      AppChip(
                        label: "Large",
                        size: AppChipSize.large,
                        type: AppChipType.filter,
                        isSelected: sizeSelection.value == 2,
                        onTap: () {
                          sizeSelection.value = 2;
                          myPrint("Large chip selected");
                        },
                      ),
                    ],
                  )),
              returnOurDivider(context: context),
              Text(
                "Loading Module Test",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Center(
                child: AppButton(
                  text: "Show Loading for 5 seconds",
                  type: AppButtonType.primary,
                  size: AppButtonSize.medium,
                  isFullWidth: true,
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
                ),
              ),
              returnOurDivider(context: context),
              Text(
                "User Profile Module",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Center(
                child: AppButton(
                  text: "Open User Profile",
                  type: AppButtonType.secondary,
                  size: AppButtonSize.medium,
                  isFullWidth: true,
                  icon: const Icon(Icons.person, size: 20),
                  onPressed: () {
                    // Initialize the binding and navigate to User Profile
                    UserProfileBinding().dependencies();
                    Get.to(
                      () => const UserProfileView(),
                      preventDuplicates: false,
                      transition: Transition.cupertino,
                    );
                  },
                ),
              ),
              returnOurDivider(context: context),
              Text(
                "Button Design System Demo",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              AppButton(
                text: "Primary Button",
                type: AppButtonType.primary,
                size: AppButtonSize.medium,
                isFullWidth: true,
                onPressed: () => myPrint("Primary button pressed"),
              ),
              const SizedBox(height: 8),
              AppButton(
                text: "Secondary Button",
                type: AppButtonType.secondary,
                size: AppButtonSize.medium,
                isFullWidth: true,
                onPressed: () => myPrint("Secondary button pressed"),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: "With Icon",
                      type: AppButtonType.primary,
                      size: AppButtonSize.small,
                      icon: const Icon(Icons.star, size: 16),
                      onPressed: () => myPrint("Icon button pressed"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppButton(
                      text: "Loading",
                      type: AppButtonType.secondary,
                      size: AppButtonSize.small,
                      isLoading: true,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              returnOurDivider(context: context),
            ],
          ),
        ),
      ),
    );
  }
}
