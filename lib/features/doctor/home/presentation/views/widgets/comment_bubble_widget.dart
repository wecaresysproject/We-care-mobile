import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CommentBubbleWidget extends StatelessWidget {
  const CommentBubbleWidget({
    super.key,
    required this.patientName,
    required this.comment,
  });

  final String patientName;
  final String comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColorsManager.secondaryColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            patientName,
            textAlign: TextAlign.right,
            style: AppTextStyles.font16blackWeight400,
          ),
          SizedBox(height: 2.h),
          Text(
            comment,
            textAlign: TextAlign.right,
            style: AppTextStyles.font14GreyWeight400,
          ),
        ],
      ),
    );
  }
}
