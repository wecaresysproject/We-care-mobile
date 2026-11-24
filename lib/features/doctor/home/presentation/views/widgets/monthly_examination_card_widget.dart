import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/monthly_examination_ring_widget.dart';

/// "المستهدف" card (physical order — the doctor home is forced LTR): the big
/// target count with its label on the left, a thin divider, then the target
/// illustration on the right.
class MonthlyTargetCardWidget extends StatelessWidget {
  const MonthlyTargetCardWidget({
    super.key,
    required this.targetCount,
    required this.label,
  });

  final int targetCount;
  final String label;

  @override
  Widget build(BuildContext context) {
    return _MonthlyCardShell(
      surfaceColor: AppColorsManager.homeTargetBlueSurface,
      accentColor: AppColorsManager.homePrimaryBlue,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '$targetCount',
                  maxLines: 1,
                  style: AppTextStyles.font22homeHeadingWeight700.copyWith(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: AppTextStyles.font22homeHeadingWeight700.copyWith(
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        _CardDivider(color: AppColorsManager.homePrimaryBlue),
        SvgPicture.asset(
          'assets/svgs/doctor_icon_target_arrow.svg',
          width: 50.w,
          height: 50.w,
        ),
      ],
    );
  }
}

/// "المحقق" card (physical order): a progress ring with the achieved count on
/// the left, a thin divider, then the title with a check badge, "نسبة
/// التحقيق" and the achieved percent on the right.
class MonthlyAchievedCardWidget extends StatelessWidget {
  const MonthlyAchievedCardWidget({
    super.key,
    required this.title,
    required this.achievedCount,
    required this.targetCount,
    required this.achievementRate,
  });

  final String title;
  final int achievedCount;
  final int targetCount;
  final int achievementRate;

  @override
  Widget build(BuildContext context) {
    const green = AppColorsManager.homeAchievedGreen;
    const greenDark = AppColorsManager.homeAchievedGreenDark;
    return _MonthlyCardShell(
      surfaceColor: AppColorsManager.homeAchievedGreenSurface,
      accentColor: green,
      children: [
        MonthlyExaminationRingWidget(
          value: achievedCount,
          total: targetCount,
          ringColor: green,
          trackColor: green.withValues(alpha: 0.18),
          valueTextStyle: AppTextStyles.font22homeHeadingWeight700.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
          ),
          diameter: 58,
          strokeWidth: 7,
        ),
        _CardDivider(color: green),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: green, size: 18.sp),
                    horizontalSpacing(5),
                    Text(
                      title,
                      maxLines: 1,
                      style: AppTextStyles.font22homeHeadingWeight700.copyWith(
                        fontSize: 15.sp,
                        color: greenDark,
                      ),
                    ),
                  ],
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'نسبة التحقيق',
                  maxLines: 1,
                  style: AppTextStyles.font13homeLabelWeight500.copyWith(
                    fontSize: 12.sp,
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '$achievementRate%',
                  maxLines: 1,
                  textDirection: TextDirection.ltr,
                  style: AppTextStyles.font22homeHeadingWeight700.copyWith(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: greenDark,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MonthlyCardShell extends StatelessWidget {
  const _MonthlyCardShell({
    required this.surfaceColor,
    required this.accentColor,
    required this.children,
  });

  final Color surfaceColor;
  final Color accentColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: accentColor.withValues(alpha: 0.28)),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.12),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(children: children),
      ),
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 52.h,
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      color: color.withValues(alpha: 0.3),
    );
  }
}
