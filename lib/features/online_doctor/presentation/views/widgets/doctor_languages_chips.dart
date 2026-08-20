import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// لغات الطبيب على شكل شيبس فى قسم "اللغات".
class DoctorLanguagesChips extends StatelessWidget {
  const DoctorLanguagesChips({super.key, required this.languages});

  final List<String> languages;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 8.h,
      children: [
        for (final language in languages)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: OnlineDoctorTheme.chipSurface,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              language,
              style: AppTextStyles.font14blackWeight400.copyWith(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: OnlineDoctorTheme.headingColor,
              ),
            ),
          ),
      ],
    );
  }
}
