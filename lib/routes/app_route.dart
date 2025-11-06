import 'package:flutter/widgets.dart';
import 'package:todo_api/screens/edit_task_screen.dart';
import 'package:todo_api/screens/todo_page_screen.dart';

class AppRoute {
  static const String todoPageScreen = '/todoPageScreen';
  static const String editTaskScreen = '/editTaskScreen';

  Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
    AppRoute.todoPageScreen: (context) => const TodoPageScreen(),
    AppRoute.editTaskScreen: (context) => const EditTaskScreen()
  };
}
