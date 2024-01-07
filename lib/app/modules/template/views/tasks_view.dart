import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/tasks_controller.dart';

class TasksView extends GetWidget<TasksController> {
  const TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoSizeText(
              'TasksView is working',
              style: TextStyle(fontSize: 20),
            ),
            AutoSizeText('ProductId: ')
          ],
        ),
      ),
    );
  }
}
