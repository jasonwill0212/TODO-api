import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_api/components/app_button.dart';
import 'package:todo_api/components/app_textformfield.dart';
import 'package:todo_api/models/task.dart';
import 'package:todo_api/providers/task_provider.dart';
import 'package:todo_api/routes/app_route.dart';
import 'package:todo_api/screens/widgets/appbar_widget.dart';
import 'package:todo_api/screens/widgets/dialog_widget.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({super.key});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>(); // ✅ đặt đúng vị trí

  late TextEditingController titleController;
  late TextEditingController descController;
  late Task task;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Task) {
      task = args;
      titleController.text = task.title;
      descController.text = task.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(showicon: false, text: 'Edit Task'),
      body: _body(),
    );
  }

  Widget _body() {
    return Form(
      key: _formKey, // Assign the GlobalKey to the Form
      child: Padding(
        padding: const EdgeInsets.fromLTRB(29, 43, 29, 43),
        child: Column(
          children: [_formFields(), const SizedBox(height: 40), _buttons()],
        ),
      ),
    );
  }

  //title and description texformfield
  Widget _formFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextformfield(
          labelText: 'Title',
          controllerText: titleController,
          validatorText: 'Title Empty',
        ),
        const SizedBox(height: 20),
        AppTextformfield(
          labelText: 'Description',
          controllerText: descController,
          validatorText: 'Description Empty',
        ),
      ],
    );
  }

  Widget _buttons() {
    final taskProvider = context.read<TaskProvider>();
    final buttonWidth = (MediaQuery.of(context).size.width - (28 + 46)) / 2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () async {
            /// Validate
            if (!_formKey.currentState!.validate()) return;

            /// Update API
            await taskProvider.updateTask(
              task: Task(
                title: titleController.text.trim(),
                description: descController.text.trim(),
                id: task.id,
              ),
            );

            if (!mounted) return;

            if (taskProvider.errorMessage.isNotEmpty) {
              showDialog(
                context: context,
                builder: (context) =>
                    const DialogWidget(textTittle: 'Error Edit Task'),
              );
            } else {
              Navigator.pop(context);
            }
          },
          child: AppButton(text: "Update", height: 65, width: buttonWidth),
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context, AppRoute.todoPage);
          },
          child: AppButton(text: 'Cancel', height: 65, width: buttonWidth),
        ),
      ],
    );
  }
}
