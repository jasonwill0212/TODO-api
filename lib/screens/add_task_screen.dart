import 'package:flutter/material.dart';
import 'package:todo_api/components/app_color.dart';
import 'package:todo_api/components/app_text.dart';
import 'package:todo_api/components/app_text_style.dart';
import 'package:todo_api/routes/app_route.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
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
