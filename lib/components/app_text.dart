import 'package:flutter/material.dart';
import 'package:todo_api/components/app_text_style.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle ?style;
  final TextAlign ?textAlign;
  const AppText({super.key,required this.text, this.textAlign, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.center,
      style: style ?? AppTextStyle.tsRegularBlack10,
    );
  }
}

