import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CustomActionButton extends StatelessWidget {
  const CustomActionButton({
    super.key,
    required this.onTap,
    this.color,
    required this.title,
    required this.icon,
  });
  final String title;
  final Function()? onTap;
  final Color? color;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? AppColorsManager.mainDarkBlue,
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
        child: Row(children: [
          Image.asset(
            icon,
            width: 13.w,
            height: 13.h,
          ),
          horizontalSpacing(2.w),
          Text(title, style: AppTextStyles.font14whiteWeight600),
        ]),
      ),
    );
  }
}
