import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'adaptive_switch_controller.dart';

class AdaptiveSwitchView extends GetView<AdaptiveSwitchController> {
  final String preferenceKey;
  final String label;
  final Function callback;

  const AdaptiveSwitchView({super.key, required this.preferenceKey, required this.label, required this.callback});

  @override
  AdaptiveSwitchController get controller => Get.put(
        AdaptiveSwitchController(preferenceKey: preferenceKey, initialValue: false),
        tag: preferenceKey,
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...[
          Text(label),
          const SizedBox(width: 8), // Add some spacing
        ],
        Obx(() => Switch.adaptive(
              value: controller.switchValue.value,
              onChanged: (value) {
                controller.switchValue.value = value;
                controller.saveSwitchState(value);
                callback(value);
              },
            )),
      ],
    );
  }
}
