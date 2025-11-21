import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_api/components/app_button.dart';
import 'package:todo_api/components/app_textformfield.dart';
import 'package:todo_api/models/task.dart';
import 'package:todo_api/providers/task_provider.dart';
import 'package:todo_api/screens/widgets/appbar_widget.dart';
import 'package:todo_api/screens/widgets/dialog_widget.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descController;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(showicon: false, text: 'Create Task'),
      body: _body(),
    );
  }

  Widget _body() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(29, 43, 29, 43),
        child: Column(
          children: [_formFields(), const SizedBox(height: 40), _buttonAdd()],
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
          validatorText: 'Title cannot be empty',
        ),
        const SizedBox(height: 20),
        AppTextformfield(
          labelText: 'Description',
          controllerText: descController,
          validatorText: 'Description cannot be empty',
        ),
      ],
    );
  }

  Widget _buttonAdd() {
    final taskProvider = context.read<TaskProvider>();

    return InkWell(
      onTap: () async {
        /// Validate
        if (!_formKey.currentState!.validate()) return;

        /// --- Call API ---
        await taskProvider.createTask(
          task: Task(
            title: titleController.text.trim(),
            description: descController.text.trim(),
          ),
        );

        if (!mounted) return;

        /// Error from provider
        if (taskProvider.errorMessage.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) =>
                const DialogWidget(textTittle: 'Fail Create Task'),
          );
          return;
        }

        /// --- Success ---
        Navigator.pop(context);
      },
      child: AppButton(
        text: 'ADD',
        height: 65,
        width: MediaQuery.of(context).size.width - 58,
      ),
    );
  }
}
