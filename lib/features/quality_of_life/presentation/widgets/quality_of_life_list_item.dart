import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class QualityOfLifeListItem extends StatelessWidget {
  final Map<int, String> answers;
  final String month;

  const QualityOfLifeListItem({
    super.key,
    required this.answers,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColorsManager.textfieldInsideColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "سجل إجابات جودة الحياة",
                  style: AppTextStyles.font16BlackSemiBold,
                ),
                SizedBox(height: 4.h),
                Text(
                  "تمت الإجابة على ${answers.length} سؤال",
                  style: AppTextStyles.font16DarkGreyWeight400,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColorsManager.babyBlueColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              month,
              style: AppTextStyles.font14BlueWeight700,
            ),
          ),
        ],
      ),
    );
  }
}
