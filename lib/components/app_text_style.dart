import 'package:flutter/material.dart';
import 'package:todo_api/components/app_color.dart';

class AppTextStyle {
  static const TextStyle tsRegularBlack10 = TextStyle(
    fontFamily: 'Jost',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColor.back,
  );
  static const TextStyle tsRegularWarmGray16 = TextStyle(
    fontFamily: 'Jost',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColor.warmGray,
  );

  static const TextStyle tsSemiBoldWhite24 = TextStyle(
    fontFamily: 'Jost',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColor.white,
    letterSpacing: 0,
  );
  static const TextStyle tsRegularWhite15 = TextStyle(
    fontFamily: 'Jost',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColor.white,
    letterSpacing: 0,
  );

  static const TextStyle tsSemiBoldWhite13 = TextStyle(
    fontFamily: 'Jost',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColor.pastelPurple,
    letterSpacing: 0,
  );

  static const TextStyle tsSemiBoldPastelPurple18 = TextStyle(
    fontFamily: 'Jost',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColor.pastelPurple,
    letterSpacing: 0,
  );

  static const TextStyle tsSemiBoldWhite20 = TextStyle(
    fontFamily: 'Jost',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColor.white,
    letterSpacing: 0,
  );
  static const TextStyle tsSemiBoldred20 = TextStyle(
    fontFamily: 'Jost',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Color.fromARGB(255, 255, 0, 0),
    letterSpacing: 0,
  );
  static const TextStyle tsSemiBoldblack20 = TextStyle(
    fontFamily: 'Jost',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Color.fromARGB(255, 0, 0, 0),
    letterSpacing: 0,
  );

  static TextStyle? get tsSemiBoldwhite16 => null;
}
