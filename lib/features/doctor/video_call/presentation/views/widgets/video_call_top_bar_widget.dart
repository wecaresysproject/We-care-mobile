import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/generated/l10n.dart';

/// Top overlay row on the video call screen: shield icon, live status pill
/// ("الكشف جاري | 00:00") and the more-options icon.
class VideoCallTopBarWidget extends StatelessWidget {
  const VideoCallTopBarWidget({super.key, required this.elapsedLabel});

  final String elapsedLabel;

  @override
  Widget build(BuildContext context) {
    final pillTextStyle = AppTextStyles.font14WhiteWeight700.copyWith(
      fontSize: 12.sp,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _OverlayIconButton(icon: Icons.shield_outlined, onTap: () {}),
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColorsManager.videoCallStatusPillBackground,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7.r,
                  height: 7.r,
                  decoration: const BoxDecoration(
                    color: AppColorsManager.videoCallLiveDotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Flexible(
                  child: Text(
                    S.of(context).examinationInProgressLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: pillTextStyle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text('|', style: pillTextStyle),
                SizedBox(width: 6.w),
                Text(elapsedLabel, style: pillTextStyle),
              ],
            ),
          ),
        ),
        _OverlayIconButton(icon: Icons.more_horiz, onTap: () {}),
      ],
    );
  }
}

class _OverlayIconButton extends StatelessWidget {
  const _OverlayIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColorsManager.videoCallOverlayIconBackground,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(10.r),
          child: Icon(
            icon,
            size: 20.r,
            color: AppColorsManager.scaffoldBackGroundColor,
          ),
        ),
      ),
    );
  }
}
