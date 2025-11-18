import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_api/components/app_color.dart';
import 'package:todo_api/components/app_text.dart';
import 'package:todo_api/components/app_text_style.dart';
import 'package:todo_api/models/task.dart';
import 'package:todo_api/providers/task_provider.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  late TextEditingController titleController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: 'Nobita');
    descController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColor.pastelPurple,
        titleSpacing: 0,
        title: Padding(
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
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(29, 43, 29, 43),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: titleController,
                  onChanged: (value) {
                    debugPrint('value: $value');
                    debugPrint('titleController: ${titleController.text}');
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: AppTextStyle.tsRegularWarmGray16,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: AppTextStyle.tsRegularWarmGray16,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              await context.read<TaskProvider>().createTask(
                task: Task(
                  title: titleController.text.trim(),
                  description: descController.text.trim(),
                ),
              );

              /// Error case

              if (context.mounted) {
                if (Provider.of<TaskProvider>(
                  context,
                  listen: false,
                ).errorMessage.isNotEmpty) {
                  /// show dialog notify error
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: AppColor.lavenderMist,
                        title: AppText(
                          text: 'Error Create Task',
                          style: AppTextStyle.tsSemiBoldblack20,
                        ),
                        content: AppText(
                          text: context.watch<TaskProvider>().errorMessage,
                          style: AppTextStyle.tsRegularBlack10,
                        ),
                        actions: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);

                              /// clear error message
                              context.read<TaskProvider>().setErrorMessage('');
                            },
                            child: AppText(
                              text: 'OK',
                              style: AppTextStyle.tsSemiBoldPastelPurple18,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else if (Provider.of<TaskProvider>(
                  context,
                  listen: false,
                ).errorMessage.isEmpty) {
                  Navigator.pop(context);
                  await context.read<TaskProvider>().getAllTasks();
                } else {
                  debugPrint("Failed to create task in create_task_page.dart");
                }
              }
            },
            borderRadius: BorderRadius.circular(15),
            child: Container(
              alignment: Alignment.center,
              width: 170,
              height: 65,
              decoration: BoxDecoration(
                color: AppColor.pastelPurple,
                borderRadius: BorderRadius.circular(15),
              ),
              child: AppText(
                text: 'ADD',
                style: AppTextStyle.tsSemiBoldWhite20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
