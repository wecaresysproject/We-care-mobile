import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/generated/l10n.dart';

/// The page-header banner at the top of the Monthly Examination Target
/// screen: a target/bullseye icon badge + title/subtitle on the leading
/// side, a small target+chart icon badge on the trailing side. Mirrors
/// [ServicePricesBannerWidget]/[BookingSettingsBannerWidget]'s tinted
/// rounded-container pattern.
class MonthlyExaminationTargetBannerWidget extends StatelessWidget {
  const MonthlyExaminationTargetBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColorsManager.basicDataScaffoldBackground,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: AppColorsManager.basicDataVioletBadgeBackground,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.track_changes_outlined,
              size: 28.r,
              color: AppColorsManager.basicDataVioletBadgeIcon,
            ),
          ),
          horizontalSpacing(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localization.monthlyExaminationTargetAction,
                  style: AppTextStyles.font20blackWeight700
                      .copyWith(color: AppColorsManager.mainDarkBlue),
                ),
                verticalSpacing(6),
                Text(
                  localization.monthlyExaminationTargetFormBannerSubtitle,
                  style: AppTextStyles.font13GreyWeight400,
                ),
              ],
            ),
          ),
          horizontalSpacing(12),
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColorsManager.basicDataSkyBadgeBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.insights_outlined,
              size: 18.r,
              color: AppColorsManager.basicDataSkyBadgeIcon,
            ),
          ),
        ],
      ),
    );
  }
}
