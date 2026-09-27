import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/generated/l10n.dart';

/// The light-blue tinted info row explaining that the completion percentage
/// will surface on the doctor home page automatically.
class MonthlyGoalInfoBannerWidget extends StatelessWidget {
  const MonthlyGoalInfoBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColorsManager.todayInfoBannerBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: AppColorsManager.basicDataBlueBadgeBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline,
              size: 16.r,
              color: AppColorsManager.basicDataBlueBadgeIcon,
            ),
          ),
          horizontalSpacing(10),
          Expanded(
            child: Text(
              S.of(context).monthlyExaminationTargetFormInfoBanner,
              style: AppTextStyles.font13GreyWeight400,
            ),
          ),
        ],
      ),
    );
  }
}
