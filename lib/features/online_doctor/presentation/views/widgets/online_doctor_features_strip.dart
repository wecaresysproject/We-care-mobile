import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

class OnlineDoctorFeaturesStrip extends StatelessWidget {
  const OnlineDoctorFeaturesStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: OnlineDoctorTheme.cardSurface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: OnlineDoctorTheme.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Expanded(
            child: _FeatureTile(
              icon: Icons.groups_rounded,
              title: "أطباء موثوقون",
              description: "شبكة من الأطباء المتخصصين",
            ),
          ),
          _FeatureDivider(),
          Expanded(
            child: _FeatureTile(
              icon: Icons.access_time_filled_rounded,
              title: "متوفر 24/7",
              description: "تواصل مع الأطباء في أي وقت",
            ),
          ),
          _FeatureDivider(),
          Expanded(
            child: _FeatureTile(
              icon: Icons.verified_user_rounded,
              title: "آمن وسري",
              description: "نحافظ على خصوصية بياناتك الطبية",
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: AppColorsManager.mainDarkBlue,
        ),
        horizontalSpacing(5),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  title,
                  style: AppTextStyles.font12blackWeight400.copyWith(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                    color: OnlineDoctorTheme.headingColor,
                  ),
                ),
              ),
              verticalSpacing(2),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font12blackWeight400.copyWith(
                  fontSize: 8.5.sp,
                  height: 1.45,
                  color: OnlineDoctorTheme.bodyColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeatureDivider extends StatelessWidget {
  const _FeatureDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 38.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      color: OnlineDoctorTheme.cardBorder,
    );
  }
}
