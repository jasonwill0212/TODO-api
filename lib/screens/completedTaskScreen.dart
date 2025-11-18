import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_api/components/app_color.dart';
import 'package:todo_api/components/app_text.dart';
import 'package:todo_api/components/app_text_style.dart';
import 'package:todo_api/providers/task_provider.dart';

class Completedtaskscreen extends StatelessWidget {
  const Completedtaskscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
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
            itemCount: taskProvider.completedTasks.length,
            itemBuilder: (context, index) {
              final item = taskProvider.completedTasks[index];
              return Container(
                margin: const EdgeInsets.fromLTRB(7, 22, 7, 0),
                width: screenWidth - 14,
                height: (82 / 896) * screenHeight,
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
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
