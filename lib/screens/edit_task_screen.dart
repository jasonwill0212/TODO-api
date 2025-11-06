import 'package:flutter/material.dart';
import 'package:todo_api/components/app_color.dart';
import 'package:todo_api/components/app_text_style.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(29),
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
            const SizedBox(height: 30),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context, {
                    'title': titleController.text,
                    'description': descController.text,
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColor.pastelPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
