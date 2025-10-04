import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'adaptive_switch_controller.dart';

class AdaptiveSwitchView extends GetView<AdaptiveSwitchController> {
  final String preferenceKey;
  final Function callback;

  const AdaptiveSwitchView(
      {super.key, required this.preferenceKey, required this.callback});

  @override
  AdaptiveSwitchController get controller => Get.put(
        AdaptiveSwitchController(
            preferenceKey: preferenceKey, initialValue: false),
        tag: preferenceKey,
      );

  @override
  Widget build(BuildContext context) {
    // Get theme colors for consistent styling
    final primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final outlineColor = Theme.of(context).colorScheme.outline;

    return Row(
      children: [
        Obx(() => Switch.adaptive(
              value: controller.switchValue.value,
              onChanged: (value) {
                controller.switchValue.value = value;
                controller.saveSwitchState(value);
                callback(value);
              },
              // Consistent theming with our design system
              activeColor: primaryColor,
              activeTrackColor: primaryColor.withOpacity(0.3),
              inactiveThumbColor: surfaceColor,
              inactiveTrackColor: outlineColor.withOpacity(0.3),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )),
      ],
    );
  }
}
