import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/monthly_examination_ring_widget.dart';

/// One of the two "الكشوفات الشهرية" cards (target/orange or
/// achieved/green): a progress ring on the leading side, a thin vertical
/// divider, then the title + icon and an optional [subtitle] ("نسبة تحقيق
/// N%" on the achieved card; the target card has none).
class MonthlyExaminationCardWidget extends StatelessWidget {
  const MonthlyExaminationCardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.ringMax,
    this.subtitle,
    required this.iconAssetPath,
    required this.accentColor,
    required this.accentColorDark,
    required this.surfaceColor,
  });

  final String title;
  final int value;

  /// Denominator the ring arc fills against (the monthly target).
  final int ringMax;
  final String? subtitle;
  final String iconAssetPath;
  final Color accentColor;
  final Color accentColorDark;
  final Color surfaceColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: accentColor.withValues(alpha: 0.35)),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.18),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            MonthlyExaminationRingWidget(
              value: value,
              total: ringMax,
              ringColor: accentColor,
              trackColor: accentColor.withValues(alpha: 0.18),
              valueTextStyle: AppTextStyles.font18homeCardValueWeight700
                  .copyWith(color: accentColorDark),
              diameter: 44,
            ),
            horizontalSpacing(5),
            Container(
              width: 1,
              height: 40.h,
              color: accentColor.withValues(alpha: 0.35),
            ),
            horizontalSpacing(5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      //* scaleDown instead of an ellipsis: on narrow screens
                      //* the title shrinks further but is never cut to "...".
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            title,
                            maxLines: 1,
                            style: AppTextStyles.font15homeCardTitleWeight700
                                .copyWith(
                              color: accentColorDark,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                      horizontalSpacing(3),
                      SvgPicture.asset(
                        iconAssetPath,
                        width: 13.w,
                        height: 13.w,
                        colorFilter: ColorFilter.mode(
                          accentColorDark,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                  if (subtitle != null) ...[
                    verticalSpacing(3),
                    Text(
                      subtitle!,
                      maxLines: 2,
                      style: AppTextStyles.font12homeCardSubtitleWeight500
                          .copyWith(color: accentColorDark),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
