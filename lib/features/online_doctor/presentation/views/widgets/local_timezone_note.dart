import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// تنويه إن كل المواعيد بالتوقيت المحلى لمصر — بيظهر فى "حجوزاتى" و"الكشف".
class LocalTimezoneNote extends StatelessWidget {
  const LocalTimezoneNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: OnlineDoctorTheme.iconTint,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 15.sp,
            color: AppColorsManager.mainDarkBlue,
          ),
          horizontalSpacing(6),
          Flexible(
            child: Text(
              "جميع المواعيد حسب التوقيت المحلي لجمهورية مصر العربية",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: OnlineDoctorTheme.headingColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
