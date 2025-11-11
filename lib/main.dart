import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_api/providers/task_provider.dart';
import 'package:todo_api/routes/app_route.dart';

void main() {
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
        initialRoute: AppRoute.todoPageScreen,
        routes: AppRoute().routes,

        // home: ChangeNotifierProvider(
        //   create: (context) => TaskProvider(),
        //   child: const DemoProvider(),
        // ),
      ),
    );
  }
}

// class DemoProvider extends StatelessWidget {
//   const DemoProvider({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final taskProvider = context.watch<TaskProvider>();
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text('test', style: TextStyle()),
//           // Consumer<TaskProvider>(
//           //   builder: (context, taskProvider, child) {
//           //     return Text(taskProvider.counter.toString());
//           //   },
//           // ),
//           Selector<DemoProvider, int>(
//             selector: (context, taskProvider) => taskProvider.counter,
//             builder: (context, counter, child) {
//               return Text(counter.toString());
//             },
//           ),
//           TextButton(
//             onPressed: () {
//               context.read<DemoProvider>().increment();
//             },
//             child: Text('Increment counter'),
//           ),
//           TextButton(
//             onPressed: () {
//               context.read<DemoProvider>().decrement();
//             },
//             child: Text('Decrement. counter'),
//           ),
//           SizedBox(height: 50),
//           // Consumer<TaskProvider>(
//           //   builder: (context, taskProvider, child) {
//           //     return Text(taskProvider.age.toString());
//           //   },
//           // ),
//           Selector<DemoProvider, int>(
//             selector: (context, taskProvider) => taskProvider.age,
//             builder: (context, age, child) {
//               return Text(age.toString());
//             },
//           ),
//           TextButton(
//             onPressed: () {
//               context.read<DemoProvider>().increaseAge();
//             },
//             child: Text('Increment Age'),
//           ),
//           TextButton(
//             onPressed: () {
//               context.read<DemoProvider>().decreaseAge();
//             },
//             child: Text('Decrement Age'),
//           ),
//           Text('test', style: TextStyle()),
//         ],
//       ),
//     );
//   }
// }
