import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/we_care_brand_mark.dart';

class OnlineDoctorHeroBanner extends StatelessWidget {
  const OnlineDoctorHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      decoration: BoxDecoration(
        gradient: OnlineDoctorTheme.heroGradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: OnlineDoctorTheme.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const WeCareBrandMark(),
                verticalSpacing(18),
                Text(
                  "رعايتـك تبـدأ من هنا",
                  maxLines: 2,
                  style: AppTextStyles.font20blackWeight600.copyWith(
                    fontSize: 18.5.sp,
                    fontWeight: FontWeight.w700,
                    color: OnlineDoctorTheme.headingColor,
                  ),
                ),
                verticalSpacing(8),
                Text(
                  "تواصل مع أفضل الأطباء في أي وقت وأي مكان عبر منصة WECARE SYS",
                  style: AppTextStyles.font12blackWeight400.copyWith(
                    fontSize: 11.5.sp,
                    height: 1.7,
                    color: OnlineDoctorTheme.bodyColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          const _HeroShieldIllustration(),
        ],
      ),
    );
  }
}

/// سماعة وقلب بنبض جوه دائرة زرقاء فاتحة — بديل الصورة المركّبة اللى فى التصميم.
class _HeroShieldIllustration extends StatelessWidget {
  const _HeroShieldIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104.w,
      height: 104.h,
      padding: EdgeInsets.all(15.w),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFD5E8FA)],
        ),
      ),
      child: Image.asset(
        "assets/images/medical_service_providers.png",
        fit: BoxFit.contain,
      ),
    );
  }
}
