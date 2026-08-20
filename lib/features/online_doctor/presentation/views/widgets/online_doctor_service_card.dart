import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

class OnlineDoctorServiceCard extends StatelessWidget {
  const OnlineDoctorServiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String description;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 10.h),
        decoration: BoxDecoration(
          color: OnlineDoctorTheme.cardSurface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: OnlineDoctorTheme.cardBorder),
          boxShadow: [
            BoxShadow(
              color: AppColorsManager.mainDarkBlue.withAlpha(15),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58.w,
              height: 58.h,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: OnlineDoctorTheme.iconTint,
                shape: BoxShape.circle,
              ),
              child: icon,
            ),
            verticalSpacing(12),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: AppTextStyles.font16BlackSemiBold.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: OnlineDoctorTheme.headingColor,
                ),
              ),
            ),
            verticalSpacing(6),
            //* ارتفاع ثابت لـ 3 سطور عشان السهم يبقى فى نفس المستوى فى الكروت
            //* التلاتة مهما اختلف طول الوصف.
            SizedBox(
              height: 48.h,
              child: Text(
                description,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font12blackWeight400.copyWith(
                  fontSize: 9.5.sp,
                  height: 1.6,
                  color: OnlineDoctorTheme.bodyColor,
                ),
              ),
            ),
            verticalSpacing(8),
            Container(
              width: 30.w,
              height: 30.h,

              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColorsManager.mainDarkBlue,
                shape: BoxShape.circle,
              ),
              //* الأيقونة دى بتتعكس تلقائياً فى RTL، والتصميم عايزها ">" دايماً.
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
