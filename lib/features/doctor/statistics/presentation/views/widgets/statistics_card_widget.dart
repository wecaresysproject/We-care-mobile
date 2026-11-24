import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

const _navy = Color(0xFF0E2A5E);
const _divider = Color(0xFFBFDDF3);

/// One "إحصائيات" card: the illustration on the right, a thin divider, then
/// the title and the big number centered. [isWide] cards take the full row.
class StatisticsCardWidget extends StatelessWidget {
  const StatisticsCardWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.unit,
    this.isWide = false,
  });

  /// The `doctor_stats_<icon>.svg` asset.
  final String icon;
  final String title;
  final String value;

  /// Smaller text after the number: "EGP", "ساعة", "min".
  final String? unit;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final iconSize = isWide ? 58.r : 44.r;
    // Latin units read after the number ("245,800 EGP"), Arabic ones too
    // ("36 ساعة") — each in its own script's direction.
    final unitIsLatin = unit != null && RegExp(r'^[A-Za-z]').hasMatch(unit!);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 14.w : 8.w,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE6F0FA)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D6FD1).withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: SvgPicture.asset(
                'assets/svgs/doctor_stats_$icon.svg',
                width: iconSize,
                height: iconSize,
              ),
            ),
            Container(
              width: 1.5,
              margin: EdgeInsets.symmetric(
                horizontal: isWide ? 14.w : 6.w,
                vertical: 6.h,
              ),
              color: _divider,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font14blackWeight400.copyWith(
                      fontSize: isWide ? 13.sp : 11.5.sp,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                      color: _navy,
                    ),
                  ),
                  verticalSpacing(4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: value),
                          if (unit != null)
                            TextSpan(
                              text: " $unit",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                        ],
                      ),
                      maxLines: 1,
                      textDirection:
                          unitIsLatin ? TextDirection.ltr : TextDirection.rtl,
                      style: AppTextStyles.font20blackWeight700.copyWith(
                        fontSize: 24.sp,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                        color: _navy,
                      ),
                    ),
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
