import 'package:flutter/material.dart';
import 'package:todo_api/components/app_color.dart';

class AppCardContainer extends StatelessWidget {
  final Widget? child;
  const AppCardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
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
      child: child,
    );
  }
}
