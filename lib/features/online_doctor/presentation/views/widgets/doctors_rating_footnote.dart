import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// تنويه أسفل قايمة الأطباء بيوضح إن التقييمات من آراء المرضى.
class DoctorsRatingFootnote extends StatelessWidget {
  const DoctorsRatingFootnote({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 14.sp,
            color: OnlineDoctorTheme.bodyColor,
          ),
          horizontalSpacing(5),
          Flexible(
            child: Text(
              "التقييمات من 5 نجوم وتعكس أراء المرضى",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontSize: 10.sp,
                color: OnlineDoctorTheme.bodyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
