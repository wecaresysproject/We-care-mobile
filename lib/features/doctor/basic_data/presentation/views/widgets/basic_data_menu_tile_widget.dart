import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class BasicDataMenuTileWidget extends StatelessWidget {
  const BasicDataMenuTileWidget({
    super.key,
    required this.iconAssetPath,
    required this.label,
    required this.badgeBackgroundColor,
    this.onTap,
  });

  final String iconAssetPath;
  final String label;
  final Color badgeBackgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColorsManager.basicDataTileBackground,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: badgeBackgroundColor,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(5.r),
              child: SvgPicture.asset(iconAssetPath),
            ),
            SizedBox(height: 6.h),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font12blackWeight500.copyWith(
                color: AppColorsManager.mainDarkBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
