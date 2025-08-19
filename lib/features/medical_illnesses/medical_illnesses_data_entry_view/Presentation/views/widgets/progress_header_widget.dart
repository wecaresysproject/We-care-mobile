// Progress header component
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class ProgressHeader extends StatelessWidget {
  final double progress;

  const ProgressHeader({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20, left: 8.w, right: 8.w, top: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: Color(0xffE4E7EB),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColorsManager.mainDarkBlue,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          verticalSpacing(4),
          Row(
            children: [
              Text(
                '${(progress * 100).toInt()}%',
                style: AppTextStyles.font22WhiteWeight600.copyWith(
                  fontSize: 16.sp,
                  color: AppColorsManager.mainDarkBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
