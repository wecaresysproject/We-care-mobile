import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

/// One tinted quick-action tile in the video call screen's bottom sheet grid
/// (e.g. "توافق دواء جديد", "الملف الطبي").
class VideoCallActionTileWidget extends StatelessWidget {
  const VideoCallActionTileWidget({
    super.key,
    required this.iconAssetPath,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
    this.onTap,
  });

  final String iconAssetPath;
  final String label;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(iconAssetPath, width: 24.w, height: 24.h),
              SizedBox(height: 8.h),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font12Weight600.copyWith(
                  color: iconColor,
                ),
              ),
              SizedBox(height: 6.h),
              Icon(Icons.arrow_forward, size: 14.r, color: iconColor),
            ],
          ),
        ),
      ),
    );
  }
}
