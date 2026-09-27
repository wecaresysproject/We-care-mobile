import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/monthly_examination_card_widget.dart';
import 'package:we_care/generated/l10n.dart';

/// "الكشوفات الشهرية" section: a centered title with a calendar icon and
/// decorative divider lines, followed by the achieved (green) and target
/// (orange) cards side by side.
class MonthlyExaminationsSectionWidget extends StatelessWidget {
  const MonthlyExaminationsSectionWidget({
    super.key,
    required this.achievedExaminationsCount,
    required this.monthlyTargetExaminationsCount,
    required this.yearlyTargetExaminationsCount,
  });

  final int achievedExaminationsCount;
  final int monthlyTargetExaminationsCount;
  final int yearlyTargetExaminationsCount;

  /// Share of this month's target already achieved, as a whole percent.
  int get _achievementRate => monthlyTargetExaminationsCount <= 0
      ? 0
      : (achievedExaminationsCount * 100 / monthlyTargetExaminationsCount)
          .round();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColorsManager.homeSectionSurface,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: AppColorsManager.homeHeadingDarkBlue.withValues(
              alpha: 0.06,
            ),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  height: 1,
                  constraints: BoxConstraints(maxWidth: 46.w),
                  color: AppColorsManager.homeDividerColor,
                ),
              ),
              horizontalSpacing(10),
              Text(
                S.of(context).monthlyExaminationsSectionTitle,
                maxLines: 1,
                style: AppTextStyles.font22homeHeadingWeight700.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              horizontalSpacing(8),
              SvgPicture.asset(
                'assets/svgs/doctor_icon_allowed_bookings.svg',
                width: 20.w,
                height: 20.w,
                colorFilter: ColorFilter.mode(
                  AppColorsManager.homePrimaryBlue,
                  BlendMode.srcIn,
                ),
              ),
              horizontalSpacing(10),
              Flexible(
                child: Container(
                  height: 1,
                  constraints: BoxConstraints(maxWidth: 46.w),
                  color: AppColorsManager.homeDividerColor,
                ),
              ),
            ],
          ),
          verticalSpacing(16),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MonthlyExaminationCardWidget(
                  title: S.of(context).achievedLabel,
                  value: achievedExaminationsCount,
                  ringMax: monthlyTargetExaminationsCount,
                  subtitle: S.of(context).achievementRateLabel(
                        _achievementRate,
                      ),
                  iconAssetPath: 'assets/svgs/doctor_icon_correct.svg',
                  accentColor: AppColorsManager.homeAchievedGreen,
                  accentColorDark: AppColorsManager.homeAchievedGreenDark,
                  surfaceColor: AppColorsManager.homeAchievedGreenSurface,
                ),
                horizontalSpacing(12),
                MonthlyExaminationCardWidget(
                  title: S.of(context).monthlyTargetLabel,
                  value: monthlyTargetExaminationsCount,
                  ringMax: monthlyTargetExaminationsCount,
                  iconAssetPath: 'assets/svgs/doctor_icon_monthly_target.svg',
                  accentColor: AppColorsManager.homeTargetOrange,
                  accentColorDark: AppColorsManager.homeTargetOrangeDark,
                  surfaceColor: AppColorsManager.homeTargetOrangeSurface,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
