import 'package:flutter_getx_template/app/modules/tasks/controller/tasks_controller.dart';
import 'package:get/get.dart';

class TasksBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.put(TasksController())];
  }
}
