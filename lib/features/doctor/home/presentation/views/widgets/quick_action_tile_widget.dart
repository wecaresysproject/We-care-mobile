import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// One card of the home quick-actions grid: a white rounded card with a soft
/// blue shadow, a glossy illustration icon and a bold (up to two-line)
/// label. [showLiveDot] adds the small green "available" dot in the card's
/// top-left corner (used by "تفعيل جلسة أونلاين").
class QuickActionTileWidget extends StatelessWidget {
  const QuickActionTileWidget({
    super.key,
    required this.iconAssetPath,
    required this.label,
    this.showLiveDot = false,
    this.onTap,
  });

  final String iconAssetPath;
  final String label;
  final bool showLiveDot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(22.r);
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: AppColorsManager.homePrimaryBlue.withValues(alpha: 0.10),
              offset: const Offset(0, 6),
              blurRadius: 16,
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          borderRadius: radius,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(4.w, 16.h, 4.w, 14.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        iconAssetPath,
                        width: 54.w,
                        height: 54.w,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.medium,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.font22homeHeadingWeight700
                            .copyWith(fontSize: 13.sp, height: 1.35),
                      ),
                    ],
                  ),
                ),
                if (showLiveDot)
                  PositionedDirectional(
                    top: 12.h,
                    start: 12.w,
                    child: Container(
                      width: 9.w,
                      height: 9.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColorsManager.homeAchievedGreen,
                        boxShadow: [
                          BoxShadow(
                            color: AppColorsManager.homeAchievedGreen
                                .withValues(alpha: 0.35),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
