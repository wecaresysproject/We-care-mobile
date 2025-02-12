import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class SelectImageContainer extends StatelessWidget {
  final String imagePath;
  final String label;
  final void Function()? onTap;
  final Color containerBorderColor;

  const SelectImageContainer({
    super.key,
    required this.imagePath,
    required this.label,
    required this.onTap,
    this.containerBorderColor = AppColorsManager.textfieldOutsideBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 52.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: containerBorderColor,
                width: 0.8,
              ),
              color: AppColorsManager.textfieldInsideColor.withAlpha(100),
            ),
            child: Row(
              children: [
                Image.asset(
                  imagePath,
                  width: 23.3.h,
                  height: 21.w,
                ),
                horizontalSpacing(18.3),
                Text(
                  label,
                  style: AppTextStyles.font16DarkGreyWeight400,
                ),
                Spacer(),
                Image.asset(
                  "assets/images/image_arrow.png",
                  height: 15.h,
                  width: 17.w,
                ),
              ],
            ),
          ),
          if (containerBorderColor ==
              AppColorsManager
                  .warningColor) // Show error message if required and not selected
            Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: Text(
                context.translate.required_field,
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
              ),
            ),
        ],
      ),
    );
  }
}
