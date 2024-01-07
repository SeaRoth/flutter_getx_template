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
            Text(
              'TasksView is working',
              style: TextStyle(fontSize: 20),
            ),
            Text('ProductId: ')
          ],
        ),
      ),
    );
  }
}
