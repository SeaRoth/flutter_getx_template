import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/profile_controller.dart';

class ProfileView extends GetWidget<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoSizeText(
              'ProfileView is working',
              style: TextStyle(fontSize: 20),
            ),
            Obx(() => AutoSizeText(controller.profileText.value)),
          ],
        ),
      ),
    );
  }
}
