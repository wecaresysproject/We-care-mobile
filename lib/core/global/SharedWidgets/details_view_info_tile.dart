import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class DetailsViewInfoTile extends StatelessWidget {
  final String title;
  final String value;
  final String icon;
  final bool isExpanded;

  const DetailsViewInfoTile(
      {super.key,
      required this.title,
      required this.value,
      required this.icon,
      this.isExpanded = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(icon, height: 14.h, width: 14.w),
            horizontalSpacing(2),
            Text(
              title,
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
          ],
        ),
        verticalSpacing(8),
        SizedBox(
          width: isExpanded
              ? MediaQuery.of(context).size.width - 32.w
              : (MediaQuery.of(context).size.width * 0.5) - 24.w,
          child: Container(
            padding: EdgeInsets.fromLTRB(4.w, 8.h, 14.w, 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border:
                  Border.all(color: AppColorsManager.mainDarkBlue, width: 0.3),
              gradient: const LinearGradient(
                colors: [Color(0xFFECF5FF), Color(0xFFFBFDFD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              value,
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                  color: AppColorsManager.textColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}
