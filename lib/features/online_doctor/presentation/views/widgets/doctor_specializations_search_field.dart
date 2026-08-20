import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class DoctorSpecializationsSearchField extends StatelessWidget {
  const DoctorSpecializationsSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = "بحث",
    this.height = 44,
    this.borderRadius = 14,
    this.borderColor,
    this.fontSize,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;
  final double height;
  final double borderRadius;

  /// لون الحدود — بيرجع للون الافتراضى لو مش متبعت.
  final Color? borderColor;

  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final idleBorderColor = borderColor ?? AppColorsManager.placeHolderColor;
    final textSize = fontSize ?? 14;

    return SizedBox(
      height: height.h,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlign: isArabic() ? TextAlign.right : TextAlign.left,
        style: AppTextStyles.font14blackWeight400.copyWith(
          fontSize: textSize.sp,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
          hintText: hintText,
          hintStyle: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: AppColorsManager.textColor,
            fontSize: textSize.sp,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
            borderSide: BorderSide(color: idleBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
            borderSide: BorderSide(color: idleBorderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
            borderSide: BorderSide(color: AppColorsManager.mainDarkBlue),
          ),
          suffixIcon: Container(
            margin: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppColorsManager.mainDarkBlue,
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.all(8.w),
            child: Image.asset(
              "assets/images/search_icon.png",
              width: 14.w,
              height: 14.h,
            ),
          ),
          suffixIconConstraints: BoxConstraints(minWidth: 38.w),
        ),
      ),
    );
  }
}
