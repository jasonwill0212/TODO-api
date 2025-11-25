import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_api/components/app_color.dart';
import 'package:todo_api/components/app_path.dart';
import 'package:todo_api/components/app_text.dart';
import 'package:todo_api/components/app_text_style.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool showicon;
  final String text;
  const AppbarWidget({super.key, required this.showicon, required this.text});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.pastelPurple,
      title: Row(
        children: [
          AppText(text: text, style: AppTextStyle.tsSemiBoldWhite24),
          const Spacer(),
          if (showicon) SvgPicture.asset(AppPath.icCalendar),
        ],
      ),
      centerTitle: false,
      titleSpacing: 18,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
