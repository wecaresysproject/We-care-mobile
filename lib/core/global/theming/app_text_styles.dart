import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

import '../Helpers/font_weight_helper.dart';

class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  static final font18blackRegular = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.medium,
    // fontFamily: AppStrings.fontFamilyIBMPlexSansArabic,
    color: AppColorsManager.textColor,
  );
  static final font16DarkGreyWeight400 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.regular,
    // fontFamily: AppStrings.fontFamilyIBMPlexSansArabic,
    color: AppColorsManager.placeHolderColor,
  );
  static final font22MainBlueRegular = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeightHelper.bold,
    color: AppColorsManager.mainDarkBlue,
  );
  static final font22WhiteSemiBold = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeightHelper.semiBold,
    // height: 27.sp,
    color: AppColorsManager.backGroundColor,
  );
  static final font12blackRegular = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.regular,
    // fontFamily: AppStrings.fontFamilyIBMPlexSansArabic,//cairo
    color: AppColorsManager.textColor,
  );
  TextStyle generateNewTextStyle({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize.sp,
      fontWeight: fontWeight ?? FontWeightHelper.regular,
      color: color ?? AppColorsManager.textColor,
    );
  }
}
