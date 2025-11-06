import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_api/models/get_tasklist.dart';
import 'package:todo_api/routes/app_route.dart';
import 'package:todo_api/screens/todo_page_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: AppRoute.todoPageScreen,
      routes: AppRoute().routes,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> userData = {};
  UserInfo? userInfo;
  Future<void> getUserInfo() async {
    final response = await http.get(
      Uri.parse('https://task-manager-api3.p.rapidapi.com/'),
      headers: {
        'x-rapidapi-host': 'task-manager-api3.p.rapidapi.com',
        'x-rapidapi-key': '90cf59e9f8mshc64e8fe3e40f781p14fde8jsne55e29841481',
      },
    );
    if (response.statusCode == 200) {
      print('Response data: ${response.body}');

      /// Convert response.body ( String ) -> Json ( Map )
      userData = jsonDecode(response.body);
      print('User first name: ${userData['firstName']}');

      /// convert Json ( Map ) -> UserInfo object
      userInfo = UserInfo.fromJson(userData);
      print('User Info: ${userInfo?.firstName} ${userInfo?.lastName}');
    } else {
      print('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getUserInfo(),
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Center(child: Text('Hello ${userData['firstName']}')),
              // Center(child: Text('Hello ${userData['lastName']}')),
              // Center(child: Text('Hello ${userData['email']}')),
              Center(child: Text('Hello ${userInfo?.firstName}')),
              Center(child: Text('Hello ${userInfo?.lastName}')),
              Center(child: Text('Hello ${userInfo?.email}')),
            ],
          );
        },
      ),
    );
  }
}

// class UserInfo {
//   final int id;
//   final String username;
//   final String email;
//   final String firstName;
//   final String lastName;
//   final String gender;

//   UserInfo({
//     required this.id,
//     required this.username,
//     required this.email,
//     required this.firstName,
//     required this.lastName,
//     required this.gender,
//   });

//   factory UserInfo.fromJson(Map<String, dynamic> json) {
//     return UserInfo(
//       id: json['id'],
//       username: json['username'],
//       email: json['email'],
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       gender: json['gender'],
//     );
//   }
// }
