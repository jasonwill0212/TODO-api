import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_api/components/app_button_icon.dart';
import 'package:todo_api/components/app_card_container.dart';
import 'package:todo_api/components/app_path.dart';
import 'package:todo_api/components/app_text.dart';
import 'package:todo_api/components/app_text_style.dart';
import 'package:todo_api/models/task.dart';
import 'package:todo_api/providers/task_provider.dart';
import 'package:todo_api/screens/widgets/appbarWidget.dart';
import 'package:todo_api/screens/widgets/dialogWidget.dart';

class Completedtaskscreen extends StatelessWidget {
  const Completedtaskscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return Scaffold(
          appBar: Appbarwidget(showicon: false, text: 'Completed Task'),
          body: ListView.builder(
            itemCount: taskProvider.completedTasks.length,
            itemBuilder: (context, index) {
              final item = taskProvider.completedTasks[index];
              return _bodyListaskCompleted(item, context);
            },
          ),
        );
      },
    );
  }
}

//ListaskCompleted
AppCardContainer _bodyListaskCompleted(Task item, BuildContext context) {
  return AppCardContainer(
    child: Row(
      children: [
        SizedBox(width: 19),
        Row(children: [_titleAndDescription(item)]),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(right: 20),

          child: AppButtonIcon(
            onTap: () async {
              await context.read<TaskProvider>().updateTask(
                task: item.copyWith(status: 'pendiente'),
              );
              if (context.mounted) {
                if (Provider.of<TaskProvider>(
                  context,
                  listen: false,
                ).errorMessage.isNotEmpty) {
                  DialogWidget(textTittle: 'Fail');
                }
              }
            },
            iconpath: AppPath.icRestore,
          ),
        ),
      ],
    ),
  );
}

//titleAndDescription
Column _titleAndDescription(Task item) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText(
        text: item.title.trim(),
        style: AppTextStyle.tsSemiBoldWhite13.copyWith(height: 1.0),
      ),
      const SizedBox(height: 5),
      AppText(
        text: item.description.trim(),
        style: AppTextStyle.tsRegularBlack10,
      ),
    ],
  );
}
