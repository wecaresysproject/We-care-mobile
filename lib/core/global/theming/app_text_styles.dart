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
    color: AppColorsManager.textColor,
    fontFamily: "Cairo",
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
  static final font16BlackSemiBold = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.semiBold,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.textColor,
  );

  static final font14BlackMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.textColor,
  );

  //! Doctor module (lib/features/doctor)

  // Doctor home dashboard

  static final font12blackWeight500 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.medium,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.textColor,
  );
  static final font14blackWeight600 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.semiBold,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.textColor,
  );
  static final font14WhiteWeight700 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.bold,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.scaffoldBackGroundColor,
  );
  static final font12WhiteWeight700 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.bold,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.scaffoldBackGroundColor,
  );
  static final font14MainBlueWeight600 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.semiBold,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.mainDarkBlue,
  );
  static final font18MainBlueWeight500 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.medium,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.mainDarkBlue,
  );
  static final font16blackWeight400 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.regular,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.textColor,
  );
  static final font14GreyWeight400 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.textfieldOutsideBorderColor,
  );
  static final font16MainBlueWeight600 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.semiBold,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.mainDarkBlue,
  );

  // Doctor home dashboard — redesign

  static final font20homeHeadingWeight700 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeightHelper.bold,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.homeHeadingDarkBlue,
  );
  static final font22homeHeadingWeight700 = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeightHelper.bold,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.homeHeadingDarkBlue,
  );
  static final font13homeLabelWeight500 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeightHelper.medium,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.homeHeadingDarkBlue,
  );
  static final font18homeCardValueWeight700 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.bold,
    fontFamily: AppStrings.cairoFontFamily,
  );
  static final font15homeCardTitleWeight700 = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeightHelper.bold,
    fontFamily: AppStrings.cairoFontFamily,
  );
  static final font12homeCardSubtitleWeight500 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.medium,
    fontFamily: AppStrings.cairoFontFamily,
  );
  static final font15WhiteWeight700 = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeightHelper.bold,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.scaffoldBackGroundColor,
  );
  static final font20WhiteWeight700 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeightHelper.bold,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.scaffoldBackGroundColor,
  );
  static final font11WhiteWeight500 = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeightHelper.medium,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.scaffoldBackGroundColor,
  );

  // Bookings / online-session screen

  static final font20blackWeight700 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeightHelper.bold,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.textColor,
  );
  static final font13GreyWeight400 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeightHelper.regular,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.placeHolderColor,
  );

  /// Base for badge/button labels whose color varies by state — apply via
  /// `.copyWith(color: ...)` rather than adding one style per color.
  static final font12Weight600 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.semiBold,
    fontFamily: AppStrings.cairoFontFamily,
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
