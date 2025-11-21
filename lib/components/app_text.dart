import 'package:flutter/material.dart';
import 'package:todo_api/components/app_text_style.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int maxLines;
  final TextOverflow overflow;

  const AppText({
    super.key,
    required this.text,
    this.textAlign,
    this.style,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign ?? TextAlign.center,
      style: style ?? AppTextStyle.tsRegularBlack10,
    );
  }
}
