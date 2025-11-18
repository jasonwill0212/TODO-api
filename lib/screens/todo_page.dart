import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_api/components/app_color.dart';
import 'package:todo_api/components/app_path.dart';
import 'package:todo_api/components/app_text.dart';
import 'package:todo_api/components/app_text_style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_api/models/task.dart';
import 'package:todo_api/providers/task_provider.dart';
import 'package:todo_api/routes/app_route.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().getAllTasks();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    return Scaffold(
      backgroundColor: AppColor.lavenderMist,
      appBar: AppBar(
        backgroundColor: AppColor.pastelPurple,
        title: Row(
          children: [
            AppText(text: 'TODO APP', style: AppTextStyle.tsSemiBoldWhite24),
            const Spacer(),
            SvgPicture.asset(AppPath.icCalendar),
          ],
        ),
        centerTitle: false,
        titleSpacing: 18,
      ),
      body: Consumer<TaskProvider>(
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
                    _buildTitleAndDescWidget(item),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Row(
                        children: [
                          /// Edit Task
                          InkWell(
                            onTap: () async {
                              final result = await Navigator.pushNamed(
                                context,
                                AppRoute.editTaskPage,
                                arguments: item,
                              );
                            },
                            child: SvgPicture.asset(AppPath.icPencill),
                          ),
                          SizedBox(width: 26.25),

                          /// Delete Task
                          _buildDeleteTaskWidget(item),
                          SizedBox(width: 27.29),

                          /// Complete Task
                          _buildCompleteTaskWidget(item),
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
        onPressed: () {
          Navigator.pushNamed(context, AppRoute.createTaskPage);
        },
        backgroundColor: AppColor.pastelPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: AppColor.white,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, AppRoute.completedTaskPage);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppPath.icPlaylist),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppPath.icTick),
            label: 'Completed',
          ),
        ],
      ),
    );
  }

  Column _buildTitleAndDescWidget(Task item) {
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

  InkWell _buildDeleteTaskWidget(Task item) {
    return InkWell(
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

                    /// When using ! in nullable type -> have to make sure
                    /// that value is not null
                    /// if the value is null and you still use ! -> it will
                    /// crash the app
                    // if ( item.id != null)
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

  InkWell _buildCompleteTaskWidget(Task item) {
    return InkWell(
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
