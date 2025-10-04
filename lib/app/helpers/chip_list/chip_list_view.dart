import 'package:chip_list/chip_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/helpers/chip_list/chip_list_controller.dart';
import 'package:flutter_getx_template/app/helpers/print_debug/build_print.dart';
import 'package:get/get.dart';

class ChipListView extends GetView<ChipListController> {
  final String preferenceKey;
  final List<String> chipNames;
  final Function callback;
  final bool multiSelect;

  //final RxList<int> controller.selectedMatchQueueIds = <int>[0].obs;

  const ChipListView(
      {super.key,
      required this.multiSelect,
      required this.preferenceKey,
      required this.chipNames,
      required this.callback});

  @override
  ChipListController get controller => Get.put(
        ChipListController(
            preferenceKey: preferenceKey, multiSelect: multiSelect),
        tag: preferenceKey,
      );

  @override
  Widget build(BuildContext context) {
    // Get theme-aware colors for consistent styling
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;

    return Obx(() => ChipList(
          listOfChipNames: chipNames,
          supportsMultiSelect: multiSelect,
          // Active (selected) chip styling
          activeBgColorList: List.filled(chipNames.length, primaryColor),
          activeTextColorList: List.filled(chipNames.length, onPrimaryColor),
          checkmarkColor: onPrimaryColor,
          // Inactive (unselected) chip styling
          inactiveBgColorList: List.filled(chipNames.length,
              isDarkMode ? surfaceColor.withOpacity(0.3) : surfaceColor),
          inactiveTextColorList: List.filled(chipNames.length, onSurfaceColor),
          // Layout styling
          borderRadiiList:
              List.filled(chipNames.length, 12.0), // Consistent with buttons
          shouldWrap: true,
          runSpacing: 8,
          padding: EdgeInsets.zero,
          spacing: 8,
          extraOnToggle: (int val) {
            if (multiSelect) {
              if (controller.selectedMatchQueueIds.contains(val)) {
                controller.selectedMatchQueueIds.remove(val);
              } else {
                controller.selectedMatchQueueIds.add(val);
              }
            } else {
              controller.selectedMatchQueueIds.clear();
              controller.selectedMatchQueueIds.add(val);
            }
            controller.saveMultiSelectState();
            myPrint(
                "clicked $val and ${controller.selectedMatchQueueIds.toString()}");
            callback(controller.selectedMatchQueueIds.toList());
          },
          listOfChipIndicesCurrentlySelected:
              controller.selectedMatchQueueIds.toList(),
        ));
  }
}
