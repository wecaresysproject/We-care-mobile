import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/generated/l10n.dart';

/// One of the three performance cards (المشاهدات / المشاركات / مرات الظهور):
/// a pale-blue header strip with icon + title, then the monthly and yearly
/// counts separated by a thin line.
class PerformanceStatCardWidget extends StatelessWidget {
  const PerformanceStatCardWidget({
    super.key,
    required this.title,
    required this.iconAssetPath,
    required this.monthlyCount,
    required this.yearlyCount,
  });

  final String title;
  final String iconAssetPath;
  final int monthlyCount;
  final int yearlyCount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColorsManager.homeDividerColor),
          boxShadow: [
            BoxShadow(
              color: AppColorsManager.homePrimaryBlue.withValues(alpha: 0.08),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 9.h),
              color: AppColorsManager.homeTargetBlueSurface,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      style: AppTextStyles.font22homeHeadingWeight700.copyWith(
                        fontSize: 13.sp,
                      ),
                    ),
                    horizontalSpacing(6),
                    SvgPicture.asset(iconAssetPath, width: 20.w, height: 20.w),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              child: Column(
                children: [
                  _MetricLine(
                    count: monthlyCount,
                    unit: S.of(context).perMonthLabel,
                  ),
                  Container(
                    height: 1,
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    color: AppColorsManager.homeDividerColor,
                  ),
                  _MetricLine(
                    count: yearlyCount,
                    unit: S.of(context).perYearLabel,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricLine extends StatelessWidget {
  const _MetricLine({required this.count, required this.unit});

  final int count;
  final String unit;

  @override
  Widget build(BuildContext context) {
    //* scaleDown instead of an ellipsis: large counts shrink the whole line
    //* so "فى الشهر" / "فى السنة" always shows in full.
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            maxLines: 1,
            style: AppTextStyles.font22homeHeadingWeight700.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),
          horizontalSpacing(6),
          Text(
            unit,
            maxLines: 1,
            style: AppTextStyles.font13homeLabelWeight500.copyWith(
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
