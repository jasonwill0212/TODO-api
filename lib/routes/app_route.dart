import 'package:flutter/widgets.dart';
import 'package:todo_api/screens/completedTaskScreen.dart';
import 'package:todo_api/screens/create_task_page.dart';
import 'package:todo_api/screens/edit_task_page.dart';
import 'package:todo_api/screens/todo_page.dart';

class AppRoute {
  static const String todoPage = '/todoPage';
  static const String completedTaskPage = '/completedTaskPage';
  static const String editTaskPage = '/editTaskPage';
  static const String createTaskPage = '/createTaskPage';

  Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
    AppRoute.todoPage: (context) => const TodoPage(),
    AppRoute.completedTaskPage: (context) => const Completedtaskscreen(),
    AppRoute.editTaskPage: (context) => const EditTaskPage(),
    AppRoute.createTaskPage: (context) => const CreateTaskPage(),
  };
}
