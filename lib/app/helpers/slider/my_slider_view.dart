import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/helpers/slider/my_slider_controller.dart';
import 'package:get/get.dart';

class MySliderView extends GetView<MySliderController> {
  final String preferenceKey;
  final String label;
  final Function callback;

  const MySliderView({super.key, required this.preferenceKey, required this.label, required this.callback});

  @override
  MySliderController get controller => Get.put(
        MySliderController(preferenceKey: preferenceKey, initialValue: 0.0, minimumValue: 0.0, maximumValue: 100.0),
        tag: preferenceKey,
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        const SizedBox(width: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbColor: Theme.of(context).platform == TargetPlatform.iOS ? Colors.blue : Colors.green,
            activeTrackColor: Theme.of(context).platform == TargetPlatform.iOS ? Colors.blue[200] : Colors.green[200],
            inactiveTrackColor: Theme.of(context).platform == TargetPlatform.iOS ? Colors.grey[300] : Colors.grey[400],
          ),
          child: Obx(() => Slider(
                value: controller.sliderValue.value,
                min: controller.sliderMinimumValue.value,
                max: controller.sliderMaximumValue.value,
                onChanged: (value) {
                  controller.sliderValue.value = value;
                },
                onChangeEnd: (value) {
                  callback(value);
                  controller.saveSwitchState(value);
                },
              )),
        ),
        Obx(() =>Text(controller.sliderValue.value.toStringAsFixed(0)))
      ],
    );
  }
}
