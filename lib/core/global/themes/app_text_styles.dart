import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Helpers/font_weight_helper.dart';

class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();
  static TextStyle font14WhiteRegular = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
    // fontFamily: AppStrings.fontFamilyIBMPlexSansArabic,
    color: Colors.white,
  );
}
