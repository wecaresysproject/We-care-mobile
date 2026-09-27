import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// One circular in-call control (mic / camera / end-call / speaker) with its
/// label underneath, matching the reference call screen.
class VideoCallControlButtonWidget extends StatelessWidget {
  const VideoCallControlButtonWidget({
    super.key,
    required this.icon,
    required this.label,
    this.backgroundColor = AppColorsManager.videoCallControlButtonBackground,
    this.iconColor = AppColorsManager.videoCallControlIconColor,
    this.labelColor = AppColorsManager.scaffoldBackGroundColor,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color iconColor;
  final Color labelColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: backgroundColor,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(13.r),
              child: Icon(icon, size: 22.r, color: iconColor),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.font12Weight600
              .copyWith(color: labelColor, fontSize: 11.sp),
        ),
      ],
    );
  }
}
