import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:todo_api/models/task_hive.dart';
import 'package:todo_api/providers/task_provider.dart';
import 'package:todo_api/routes/app_route.dart';

void main() async {
  await Hive.initFlutter(); // Initialize Hive for Flutter
  Hive.registerAdapter(TaskHiveAdapter());
  await Hive.openBox<TaskHive>('taskBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute: AppRoute.bottomnavigation,
        routes: AppRoute().routes,
      ),
    );
  }
}
