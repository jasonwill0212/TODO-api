import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_api/components/app_color.dart';
import 'package:todo_api/components/app_text.dart';
import 'package:todo_api/components/app_text_style.dart';
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
    titleController = TextEditingController();
    descController = TextEditingController();
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
            onTap: () {
              context.read<TaskProvider>().createTask(
                title: titleController.text,
                description: descController.text,
                status: 'pendiente',
              );
              Navigator.pop(context);
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
