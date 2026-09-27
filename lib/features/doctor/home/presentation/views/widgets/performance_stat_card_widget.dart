import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/generated/l10n.dart';

/// One of the three gradient performance cards (مرات الظهور / المشاركات / المشاهدات).
class PerformanceStatCardWidget extends StatelessWidget {
  const PerformanceStatCardWidget({
    super.key,
    required this.title,
    required this.iconAssetPath,
    required this.gradientColors,
    required this.metricTextColor,
    required this.monthlyCount,
    required this.yearlyCount,
  });

  final String title;
  final String iconAssetPath;
  final List<Color> gradientColors;

  /// Color for the two metric rows, which sit over the pale end of the
  /// gradient and so need a dark tint rather than white.
  final Color metricTextColor;
  final int monthlyCount;
  final int yearlyCount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26.r),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: gradientColors,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withValues(alpha: 0.3),
              offset: const Offset(0, 6),
              blurRadius: 14,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: -18.w,
              bottom: -18.w,
              child: Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            title,
                            maxLines: 1,
                            softWrap: false,
                            style: AppTextStyles.font15WhiteWeight700,
                          ),
                        ),
                      ),
                      horizontalSpacing(4),
                      Container(
                        width: 22.w,
                        height: 22.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.22),
                        ),
                        padding: EdgeInsets.all(5.w),
                        child: SvgPicture.asset(
                          iconAssetPath,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpacing(6),
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                  verticalSpacing(6),
                  _MetricLine(
                    count: monthlyCount,
                    unit: S.of(context).perMonthLabel,
                    textColor: metricTextColor,
                  ),
                  verticalSpacing(6),
                  _MetricLine(
                    count: yearlyCount,
                    unit: S.of(context).perYearLabel,
                    textColor: metricTextColor,
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
  const _MetricLine({
    required this.count,
    required this.unit,
    required this.textColor,
  });

  final int count;
  final String unit;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    //* scaleDown instead of an ellipsis: large counts shrink the whole line
    //* so "فى الشهر" / "فى السنة" always shows in full.
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            maxLines: 1,
            style: AppTextStyles.font20WhiteWeight700.copyWith(
              color: textColor,
              fontSize: 16.sp,
            ),
          ),
          horizontalSpacing(4),
          Text(
            unit,
            maxLines: 1,
            style:
                AppTextStyles.font11WhiteWeight500.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
