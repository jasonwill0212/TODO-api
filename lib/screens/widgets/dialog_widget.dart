import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_api/components/app_color.dart';
import 'package:todo_api/components/app_text.dart';
import 'package:todo_api/components/app_text_style.dart';
import 'package:todo_api/providers/task_provider.dart';

class DialogWidget extends StatelessWidget {
  final String textTittle;
  final List<Widget>? actions;
  const DialogWidget({super.key, required this.textTittle, this.actions});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.lavenderMist,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: AppText(text: textTittle, style: AppTextStyle.tsSemiBoldblack20),
      ),

      content: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: AppText(
          text: context.watch<TaskProvider>().errorMessage,
          style: AppTextStyle.tsSemiBoldred20,
        ),
      ),
      actions:
          actions ??
          [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.pop(context);
                context.read<TaskProvider>().setErrorMessage('');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: AppColor.pastelPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AppText(
                  text: "OK",
                  style: AppTextStyle.tsSemiBoldwhite16,
                ),
              ),
            ),
          ],
    );
  }
}
