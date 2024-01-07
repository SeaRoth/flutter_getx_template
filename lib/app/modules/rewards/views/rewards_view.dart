import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/rewards_controller.dart';

class RewardsView extends GetWidget<RewardsController> {
  const RewardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoSizeText(
              'RewardsView is working',
              style: TextStyle(fontSize: 20),
            ),
            AutoSizeText('ProductId: ')
          ],
        ),
      ),
    );
  }
}
