import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_api/components/app_card_container.dart';
import 'package:todo_api/components/app_color.dart';
import 'package:todo_api/components/app_path.dart';
import 'package:todo_api/components/app_text.dart';
import 'package:todo_api/components/app_text_style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_api/models/task.dart';
import 'package:todo_api/providers/task_provider.dart';
import 'package:todo_api/routes/app_route.dart';
import 'package:todo_api/screens/widgets/appbar_widget.dart';
import 'package:todo_api/screens/widgets/dialog_widget.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lavenderMist,
      appBar: const AppbarWidget(showicon: true, text: 'TODO APP'),
      body: _bodyTodoPage(),
    );
  }

  //body
  Consumer _bodyTodoPage() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        if (taskProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (taskProvider.errorMessage.isNotEmpty) {
          return Center(
            child: AppText(
              text: taskProvider.errorMessage,
              style: AppTextStyle.tsSemiBoldred20,
            ),
          );
        }
        if (taskProvider.pendingTasks.isEmpty) {
          return Center(
            child: AppText(
              text: 'No pending tasks available.',
              style: AppTextStyle.tsSemiBoldred20,
            ),
          );
        }
        return ListView.builder(
          itemCount: taskProvider.pendingTasks.length,
          itemBuilder: (context, index) {
            var item = taskProvider.pendingTasks[index];

            return AppCardContainer(
              child: _buttonActionDeleteEditAndComplete(item),
            );
          },
        );
      },
    );
  }

  //buttonDelete_Edit_And_Complete
  Row _buttonActionDeleteEditAndComplete(Task item) {
    return Row(
      children: [
        SizedBox(width: 19),
        _buildTitleAndDescWidget(item),
        SizedBox(width: 12),
        _editAndDeleteCompleted(item),
      ],
    );
  }

  //title and description
  Expanded _buildTitleAndDescWidget(Task item) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: item.title.trim(),
            textAlign: TextAlign.start,
            style: AppTextStyle.tsSemiBoldWhite13.copyWith(height: 1.0),
          ),
          const SizedBox(height: 5),
          AppText(
            text: item.description.trim(),
            style: AppTextStyle.tsRegularBlack10,
          ),
        ],
      ),
    );
  }

  //editAndDeleteCompleted
  Row _editAndDeleteCompleted(Task item) {
    return Row(
      children: [
        /// Edit Task
        _buildEditTaskWidget(item),
        SizedBox(width: 20),

        /// Delete Task
        _buildDeleteTaskWidget(item),
        SizedBox(width: 20),

        /// Complete Task
        _buildCompleteTaskWidget(item),
        SizedBox(width: 25),
      ],
    );
  }

  //delete
  InkWell _buildDeleteTaskWidget(Task item) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return DialogWidget(
              textTittle: 'Delete Task: ${item.title}',
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Delete'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<TaskProvider>().deleteTask(item.id!);
                  },
                ),
              ],
            );
          },
        );
      },
      child: SvgPicture.asset(AppPath.icTrash),
    );
  }

  //Edit
  InkWell _buildEditTaskWidget(Task item) {
    return InkWell(
      onTap: () async {
        await Navigator.pushNamed(
          context,
          AppRoute.editTaskPage,
          arguments: item,
        );
      },
      child: SvgPicture.asset(AppPath.icPencill),
    );
  }

  //complete
  InkWell _buildCompleteTaskWidget(Task item) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return DialogWidget(
              textTittle: 'Complete Task: ${item.title}',
              actions: [
                InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();
                    await context.read<TaskProvider>().updateTask(
                      task: item.copyWith(status: 'completada'),
                    );
                  },
                  child: AppText(
                    text: 'Complete',
                    style: AppTextStyle.tsSemiBoldPastelPurple18,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: AppText(
                    text: 'Cancel',
                    style: AppTextStyle.tsSemiBoldPastelPurple18,
                  ),
                ),
              ],
            );
          },
        );
      },
      child: SvgPicture.asset(AppPath.icCompleted),
    );
  }
}
