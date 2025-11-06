import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:todo_api/components/app_color.dart';
import 'package:todo_api/components/app_path.dart';
import 'package:todo_api/components/app_text.dart';
import 'package:todo_api/components/app_text_style.dart';
import 'package:todo_api/routes/app_route.dart';

class TodoPageScreen extends StatefulWidget {
  const TodoPageScreen({super.key});

  @override
  State<TodoPageScreen> createState() => _TodoPageScreenState();
}

class _TodoPageScreenState extends State<TodoPageScreen> {
  List<dynamic> taskList = [];

  String clean(String? s) {
    if (s == null) return '';
    return s
        .replaceAll(RegExp(r'[\u00A0\u200B\uFEFF]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  Future<void> getTaskList() async {
    final response = await http.get(
      Uri.parse('https://task-manager-api3.p.rapidapi.com/'),
      headers: {
        'x-rapidapi-host': 'task-manager-api3.p.rapidapi.com',
        'x-rapidapi-key': '7d744c6ef6msh6295387dee9a9e0p1f763djsndf07a261252a',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == "success") {
        setState(() {
          taskList = data["data"];
        });
      }
    } else {
      print("❌ Failed to load tasks: ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    getTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lavenderMist,
      appBar: AppBar(
        backgroundColor: AppColor.pastelPurple,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 18),
              child: Text(
                'TODO APP',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: SvgPicture.asset(AppPath.icCalendar, width: 30),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          final task = taskList[index];
          if (task['id'] != null) return const SizedBox.shrink();
          return Container(
            margin: const EdgeInsets.fromLTRB(7, 22, 7, 0),
            width: double.infinity,
            height: 82,
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppColor.back.withValues(alpha: 0.25),
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(width: 19),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: clean(task['title']),
                      style: AppTextStyle.tsSemiBoldWhite13.copyWith(
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 5),
                    AppText(
                      text: clean(task['description']),
                      style: AppTextStyle.tsRegularBlack10,
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            AppRoute.editTaskScreen,
                            arguments: task,
                          );

                          if (result != null &&
                              result is Map<String, dynamic>) {
                            setState(() {
                              task['title'] = result['title'] ?? task['title'];
                              task['description'] =
                                  result['description'] ?? task['description'];
                            });
                          }
                        },
                        child: SvgPicture.asset(AppPath.icPencill),
                      ),

                      SizedBox(width: 26.25),
                      SvgPicture.asset(AppPath.icTrash),
                      SizedBox(width: 27.29),
                      SvgPicture.asset(AppPath.icCompleted),
                      SizedBox(width: 30.21),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColor.white,
        onTap: (index) {},
        selectedItemColor: AppColor.pastelPurple,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppPath.icPlaylist),
            label: 'All',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppPath.icTick),
            label: 'Completed',
          ),
        ],
      ),
    );
  }
}
