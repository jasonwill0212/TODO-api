import 'package:flutter/material.dart';
import 'package:todo_api/components/app_text_style.dart';

class AppTextformfield extends StatelessWidget {
  final String labelText;
  final String validatorText;
  final TextEditingController controllerText;
  const AppTextformfield({
    super.key,
    required this.labelText,
    required this.controllerText,
    required this.validatorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) =>
          (value == null || value.trim().isEmpty) ? validatorText : null,
      controller: controllerText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: AppTextStyle.tsRegularWarmGray16,
      ),
    );
  }
}
