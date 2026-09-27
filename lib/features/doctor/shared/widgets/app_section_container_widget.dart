import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// A bordered/rounded container for one logical section of a form: a
/// centered header (icon in a colored circle badge + title) followed by
/// [child]. Use to group a form section's repeatable content — e.g. one
/// certificate type's list of entries — under a single named block.
class AppSectionContainerWidget extends StatelessWidget {
  const AppSectionContainerWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.badgeBackgroundColor,
    required this.badgeIconColor,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color badgeBackgroundColor;
  final Color badgeIconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColorsManager.basicDataTileBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColorsManager.placeHolderColor.withAlpha(60),
          width: 1.3,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: badgeBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18.r, color: badgeIconColor),
              ),
              horizontalSpacing(8),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font18blackWight500,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            verticalSpacing(6),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: AppTextStyles.font13GreyWeight400,
            ),
          ],
          verticalSpacing(16),
          child,
        ],
      ),
    );
  }
}
