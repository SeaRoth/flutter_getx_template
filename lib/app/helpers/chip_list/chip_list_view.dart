import 'package:chip_list/chip_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/helpers/chip_list/chip_list_controller.dart';
import 'package:get/get.dart';

class ChipListView extends GetView<ChipListController> {
  final String preferenceKey;
  final List<String> chipNames;
  final Function callback;
  final bool multiSelect;

  //final RxList<int> controller.selectedMatchQueueIds = <int>[0].obs;

  const ChipListView({super.key, required this.multiSelect, required this.preferenceKey, required this.chipNames, required this.callback});

  @override
  ChipListController get controller => Get.put(
        ChipListController(preferenceKey: preferenceKey, multiSelect: multiSelect),
        tag: preferenceKey,
      );

  @override
  Widget build(BuildContext context) {
    return Obx(() => ChipList(
          listOfChipNames: chipNames,
          supportsMultiSelect: multiSelect,
          // activeBgColorList: [Colors.red, Colors.black, Colors.yellow],
          // activeTextColorList: [Colors.white, Colors.white, Colors.black],
          // checkmarkColor: Theme.of(context).colorScheme.onSurfaceVariant,
          // inactiveBgColorList: [Colors.white, Colors.white, Colors.white],
          // inactiveTextColorList: [Colors.black, Colors.black, Colors.black],
          shouldWrap: true,
          runSpacing: 2,
          padding: EdgeInsets.zero,
          spacing: 2,
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
            print("clicked $val and ${controller.selectedMatchQueueIds.toString()}");
            callback(controller.selectedMatchQueueIds.toList());
          }, listOfChipIndicesCurrentlySelected: controller.selectedMatchQueueIds.toList(),
        ));
  }
}
