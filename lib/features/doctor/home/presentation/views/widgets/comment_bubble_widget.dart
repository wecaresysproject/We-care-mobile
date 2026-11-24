import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';

class CommentBubbleWidget extends StatelessWidget {
  const CommentBubbleWidget({
    super.key,
    required this.patientName,
    required this.comment,
    required this.createdAt,
  });

  final String patientName;
  final String comment;
  final DateTime createdAt;

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
          // الاسم على اليمين، والتاريخ والوقت على الشمال فى نفس السطر.
          Row(
            children: [
              Text(
                "${arabicShortDateLabel(createdAt)} - "
                "${arabicTimeLabel(createdAt)}",
                // الشاشة كلها LTR إجبارى، فلازم RTL هنا عشان ترتيب التاريخ يتقرا صح.
                textDirection: TextDirection.rtl,
                style: AppTextStyles.font13GreyWeight400,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  patientName,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font16blackWeight400,
                ),
              ),
            ],
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
