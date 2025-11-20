import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_api/components/app_color.dart';

class AppButtonIcon extends StatelessWidget {
  final String? iconpath;
  final VoidCallback onTap;
  final ColorFilter? colorFilter;
  const AppButtonIcon({
    super.key,
    required this.onTap,
    required this.iconpath,
    this.colorFilter,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(
        iconpath!,

        colorFilter:
            colorFilter ??
            ColorFilter.mode(AppColor.pastelPurple, BlendMode.srcIn),
      ),
    );
  }
}
