import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

import '../Helpers/font_weight_helper.dart';

class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  static final font18blackWight500 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.medium,
    // fontFamily: AppStrings.fontFamilyIBMPlexSansArabic,
    color: AppColorsManager.textColor,
  );
  static final font16DarkGreyWeight400 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.regular,
    color: AppColorsManager.placeHolderColor,
  );
  static final font22MainBlueWeight700 = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeightHelper.bold,
    color: AppColorsManager.mainDarkBlue,
  );
  static final font22WhiteWeight600 = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: AppColorsManager.backGroundColor,
  );
  static final font14BlueWeight700 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.bold,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.mainDarkBlue,
  );
  static final font10blueWeight400 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeightHelper.regular,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.mainDarkBlue,
  );
  static final font14blackWeight400 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.textColor,
  );

  static final font20blackWeight600 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeightHelper.semiBold,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.textColor,
  );
  static final font14whiteWeight600 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.semiBold,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.backGroundColor,
  );
  static final font12blackWeight400 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.regular,
    // fontFamily: AppStrings.fontFamilyIBMPlexSansArabic,//cairo
    color: AppColorsManager.textColor,
  );
  static final customTextStyle = TextStyle(
    fontSize: 14, // 14px
    fontWeight: FontWeight.w600, // 600 weight
    height: 17 / 14, // Line height (17px)
    letterSpacing: 0, // 0% letter spacing
    color: const Color.fromARGB(216, 1, 36, 64), // Black text color
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
