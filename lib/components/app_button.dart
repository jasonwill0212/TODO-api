import 'package:flutter/material.dart';
import 'package:todo_api/components/app_color.dart';
import 'package:todo_api/components/app_text.dart';
import 'package:todo_api/components/app_text_style.dart';

class AppButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  const AppButton({
    super.key,
    required this.text,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColor.pastelPurple,
        borderRadius: BorderRadius.circular(15),
      ),
      child: AppText(text: text, style: AppTextStyle.tsSemiBoldWhite20),
    );
  }
}
