import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/we_care_brand_mark.dart';

class OnlineDoctorPromoBanner extends StatelessWidget {
  const OnlineDoctorPromoBanner({super.key});

  static const List<IconData> _badges = [
    Icons.verified_user_outlined,
    Icons.assignment_outlined,
    Icons.monitor_heart_outlined,
    Icons.chat_bubble_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: OnlineDoctorTheme.promoGradient,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "منصة متكاملة لرعايتك الصحية",
                  maxLines: 2,
                  style: AppTextStyles.font16BlackSemiBold.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                verticalSpacing(8),
                Text(
                  "سجل بياناتك الطبية، تابع صحتك، وتواصل مع الأطباء بثقة وأمـان",
                  style: AppTextStyles.font12blackWeight400.copyWith(
                    fontSize: 10.5.sp,
                    height: 1.8,
                    color: Colors.white.withAlpha(200),
                  ),
                ),
                verticalSpacing(14),
                Row(
                  children: [
                    for (final badge in _badges) ...[
                      _BadgeIcon(icon: badge),
                      SizedBox(width: 8.w),
                    ],
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const WeCareBrandMark(
                onDarkSurface: true,
                width: 80,
              ),
              verticalSpacing(6),
              const _CaringHandsEmblem(),
            ],
          ),
        ],
      ),
    );
  }
}

class _BadgeIcon extends StatelessWidget {
  const _BadgeIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.w,
      height: 34.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withAlpha(90)),
      ),
      child: Icon(
        icon,
        size: 16.sp,
        color: Colors.white.withAlpha(230),
      ),
    );
  }
}

/// دائرة فيها رمز العائلة — بديل صورة الأيدى اللى بتحتضن الدرع فى التصميم.
class _CaringHandsEmblem extends StatelessWidget {
  const _CaringHandsEmblem();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 80.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withAlpha(28),
        border: Border.all(color: Colors.white.withAlpha(60)),
      ),
      child: Icon(
        Icons.family_restroom_rounded,
        size: 40.sp,
        color: Colors.white,
      ),
    );
  }
}
