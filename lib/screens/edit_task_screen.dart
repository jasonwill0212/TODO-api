import 'package:flutter/material.dart';
import 'package:todo_api/components/app_color.dart';
import 'package:todo_api/components/app_text.dart';
import 'package:todo_api/components/app_text_style.dart';
import 'package:todo_api/routes/app_route.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descController;
  Map<String, dynamic>? task;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      task = args;

      titleController.text = task?['title'] ?? '';
      descController.text = task?['description'] ?? '';
    }
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
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.pastelPurple,
        title: const Padding(
          padding: EdgeInsets.only(left: 18),
          child: Text(
            'Edit Task',
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
            padding: const EdgeInsets.fromLTRB(29, 43, 29, 43),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: AppTextStyle.tsRegularWarmGray16,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: AppTextStyle.tsRegularWarmGray16,
                  ),
                ),
                const SizedBox(height: 11),
              ],
            ),
          ),
          Row(
            children: [
              SizedBox(width: 14),
              InkWell(
                onTap: () {
                  Navigator.pop(context, {
                    'title': titleController.text,
                    'description': descController.text,
                  });
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
                    text: 'Update',
                    style: AppTextStyle.tsRegularWhite15,
                  ),
                ),
              ),
              SizedBox(width: 32),
              InkWell(
                onTap: () {
                  Navigator.pop(context, AppRoute.todoPageScreen);
                },
                child: Container(
                  alignment: Alignment.center,

                  width: 170,
                  height: 65,
                  decoration: BoxDecoration(
                    color: AppColor.pastelPurple,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: AppText(
                    text: 'Cancel',
                    style: AppTextStyle.tsRegularWhite15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
