import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_api/components/app_color.dart';
import 'package:todo_api/components/app_text.dart';
import 'package:todo_api/components/app_text_style.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  String clean(String? s) {
    if (s == null) return '';
    return s
        .replaceAll(RegExp(r'[\u00A0\u200B\uFEFF]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  List<dynamic> taskList = [];

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
      appBar: AppBar(
        backgroundColor: AppColor.pastelPurple,
        centerTitle: false,
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.only(left: 18),
          child: AppText(
            text: 'Completed Task',
            style: AppTextStyle.tsSemiBoldWhite24,
          ),
        ),
      ),

      body: ListView.builder(
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          final task = taskList[index];
          if (task['id'] == null) return const SizedBox();
          if (task['status'] != 'completada') return const SizedBox();
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
              ],
            ),
          );
        },
      ),
    );
  }
}
