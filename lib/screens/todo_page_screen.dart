import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:todo_api/components/app_color.dart';
import 'package:todo_api/components/app_path.dart';
import 'package:todo_api/components/app_text.dart';
import 'package:todo_api/components/app_text_style.dart';
import 'package:todo_api/models/task.dart';
import 'package:todo_api/providers/task_provider.dart';
import 'package:todo_api/routes/app_route.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TodoView();
  }
}

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  // List<dynamic> taskList = [];
  // String clean(String? s) {
  //   if (s == null) return '';
  //   return s
  //       .replaceAll(RegExp(r'[\u00A0\u200B\uFEFF]'), '')
  //       .replaceAll(RegExp(r'\s+'), ' ')
  //       .trim();
  // }

  // Future<void> deleteTask(String taskId) async {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Center(child: CircularProgressIndicator());
  //     },
  //   );
  //   final response = await http.delete(
  //     Uri.parse('https://task-manager-api3.p.rapidapi.com/$taskId'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'x-rapidapi-host': 'task-manager-api3.p.rapidapi.com',
  //       'x-rapidapi-key': '7d744c6ef6msh6295387dee9a9e0p1f763djsndf07a261252a',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     print('deleted successfully');
  //     await getTaskList();
  //   } else {
  //     print('Fail: ${response.statusCode}');
  //   }
  //   Navigator.pop(context);
  // }

  // Future<void> addTask(String title, String description) async {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Center(child: CircularProgressIndicator());
  //     },
  //   );
  //   final task = Task(title: title, description: description);
  //   final reponse = await http.post(
  //     Uri.parse('https://task-manager-api3.p.rapidapi.com/'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'x-rapidapi-host': 'task-manager-api3.p.rapidapi.com',
  //       'x-rapidapi-key': '7d744c6ef6msh6295387dee9a9e0p1f763djsndf07a261252a',
  //     },
  //     body: task.toJson(),
  //     // body: jsonEncode({
  //     //   "title": title,
  //     //   "description": description,
  //     //   "status": 'pendiente',
  //     // }),
  //   );
  //   if (reponse.statusCode == 201) {
  //     print('success');
  //   } else {
  //     print('false : ${reponse.statusCode}');
  //   }
  //   Navigator.pop(context);
  // }

  // Future<void> completeTask(
  //   String taskId,
  //   String title,
  //   String description,
  //   String status,
  // ) async {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Center(child: CircularProgressIndicator());
  //     },
  //   );
  //   final response = await http.put(
  //     Uri.parse('https://task-manager-api3.p.rapidapi.com/$taskId'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'x-rapidapi-host': 'task-manager-api3.p.rapidapi.com',
  //       'x-rapidapi-key': '7d744c6ef6msh6295387dee9a9e0p1f763djsndf07a261252a',
  //     },
  //     body: jsonEncode({
  //       "title": title,
  //       "description": description,
  //       "status": status,
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     print('complete success');
  //   } else {
  //     print('fail: ${response.statusCode}');
  //   }
  //   Navigator.pop(context);
  // }

  // Future<void> getTaskList() async {
  //   final response = await http.get(
  //     Uri.parse('https://task-manager-api3.p.rapidapi.com/'),
  //     headers: {
  //       'x-rapidapi-host': 'task-manager-api3.p.rapidapi.com',
  //       'x-rapidapi-key': '7d744c6ef6msh6295387dee9a9e0p1f763djsndf07a261252a',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     if (data["status"] == "success") {
  //       setState(() {
  //         taskList = data["data"];
  //       });
  //     }
  //   } else {
  //     print("❌ Failed to load tasks: ${response.statusCode}");
  //   }
  // }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().getAllTasks();
    });
    super.initState();
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
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          /// Loading state
          if (taskProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          /// Error state
          if (taskProvider.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                taskProvider.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          /// Empty data state
          if (taskProvider.pendingTasks.isEmpty) {
            return const Center(
              child: Text('No tasks available, please add some tasks.'),
            );
          }

          /// Data loaded state
          return ListView.builder(
            itemCount: taskProvider.pendingTasks.length,
            itemBuilder: (context, index) {
              final item = taskProvider.pendingTasks[index];

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
                          text: item.title.trim(),
                          style: AppTextStyle.tsSemiBoldWhite13.copyWith(
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 5),
                        AppText(
                          text: item.description.trim(),
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
                                arguments: item,
                              );

                              // if (result != null &&
                              //     result is Map<String, dynamic>) {
                              //   setState(() {
                              //     task['title'] =
                              //         result['title'] ?? task['title'];
                              //     task['description'] =
                              //         result['description'] ??
                              //         task['description'];
                              //   });
                              // }
                            },
                            child: SvgPicture.asset(AppPath.icPencill),
                          ),

                          SizedBox(width: 26.25),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: AppText(
                                      text: 'Delete Task: ${item.title}',
                                      style: AppTextStyle.tsSemiBoldblack20,
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(
                                            context,
                                          ).textTheme.labelLarge,
                                        ),
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(
                                            context,
                                          ).textTheme.labelLarge,
                                        ),
                                        child: const Text('Delete'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          // setState(() {
                                          //   deleteTask(task['id']);
                                          // });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: SvgPicture.asset(AppPath.icTrash),
                          ),
                          SizedBox(width: 27.29),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: AppColor.lavenderMist,
                                    title: AppText(
                                      text: 'Complete Task: ${item.title}',
                                      style: AppTextStyle.tsSemiBoldblack20,
                                    ),
                                    actions: [
                                      InkWell(
                                        onTap: () async {
                                          Navigator.of(context).pop();
                                          // await completeTask(
                                          //   task['id'],
                                          //   task['title'],
                                          //   task['description'],
                                          //   'completada',
                                          // );
                                          // await getTaskList();
                                          // setState(() {});
                                        },

                                        child: AppText(
                                          text: 'Complete',
                                          style: AppTextStyle
                                              .tsSemiBoldPastelPurple18,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: AppText(
                                          text: 'Cancel',
                                          style: AppTextStyle
                                              .tsSemiBoldPastelPurple18,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },

                            child: SvgPicture.asset(AppPath.icCompleted),
                          ),

                          SizedBox(width: 30.21),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            AppRoute.addTaskScreen,
          );
          if (result != null && result is Map<String, dynamic>) {
            // await addTask(result['title'] ?? '', result['description'] ?? '');
            // await getTaskList();
            // setState(() {});
          }
        },

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(55)),
        backgroundColor: AppColor.pastelPurple,
        child: Icon(Icons.add, color: AppColor.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: AppColor.white,

        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, AppRoute.completedTaskScreen);
          }
        },
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
