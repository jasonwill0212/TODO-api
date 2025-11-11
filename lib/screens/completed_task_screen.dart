import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_api/components/app_color.dart';
import 'package:todo_api/components/app_text.dart';
import 'package:todo_api/components/app_text_style.dart';
import 'package:todo_api/providers/task_provider.dart';

class CompletedTaskScreen extends StatelessWidget {
  const CompletedTaskScreen({super.key});

  String clean(String? s) {
    if (s == null) return '';
    return s
        .replaceAll(RegExp(r'[\u00A0\u200B\uFEFF]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
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
          if (taskProvider.completedTasks.isEmpty) {
            return const Center(
              child: Text(
                'No completed tasks available, please add some tasks.',
              ),
            );
          }

          /// Data loaded state
          return ListView.builder(
            itemCount: taskProvider.completedTasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.completedTasks[index];
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
                          text: clean(task.title),
                          style: AppTextStyle.tsSemiBoldWhite13.copyWith(
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 5),
                        AppText(
                          text: clean(task.description),
                          style: AppTextStyle.tsRegularBlack10,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
