import 'package:flutter/widgets.dart';
import 'package:todo_api/screens/add_task_screen.dart';
import 'package:todo_api/screens/completed_task_screen.dart';
import 'package:todo_api/screens/edit_task_screen.dart';
import 'package:todo_api/screens/todo_page_screen.dart';

class AppRoute {
  static const String todoPageScreen = '/todoPageScreen';
  static const String editTaskScreen = '/editTaskScreen';
  static const String addTaskScreen = '/addTaskScreen';
  static const String completedTaskScreen = '/compeleTaskScreen';

  Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
    AppRoute.todoPageScreen: (context) => const TodoScreen(),
    AppRoute.editTaskScreen: (context) => const EditTaskScreen(),
    AppRoute.addTaskScreen: (context) => const AddTaskScreen(),
    AppRoute.completedTaskScreen: (context) => const CompletedTaskScreen(),
  };
}
