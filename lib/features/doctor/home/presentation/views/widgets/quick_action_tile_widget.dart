import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class QuickActionTileWidget extends StatelessWidget {
  const QuickActionTileWidget({
    super.key,
    required this.iconAssetPath,
    required this.label,
    required this.iconWidth,
    required this.iconHeight,
    this.verticalPadding = 8,
    this.onTap,
  });

  final String iconAssetPath;
  final String label;
  final double iconWidth;
  final double iconHeight;
  final double verticalPadding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: AppColorsManager.quickActionTileBackground,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 4.w, vertical: verticalPadding.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  iconAssetPath,
                  width: iconWidth.w,
                  height: iconHeight.h,
                ),
                SizedBox(height: 2.h),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font14MainBlueWeight600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
