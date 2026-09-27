import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/generated/l10n.dart';

/// "جميع البيانات مشفرة وأمنة" pill shown above the in-call controls.
class VideoCallEncryptionNoticeWidget extends StatelessWidget {
  const VideoCallEncryptionNoticeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColorsManager.videoCallEncryptionPillBackground,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline,
            size: 13.r,
            color: AppColorsManager.scaffoldBackGroundColor,
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              S.of(context).encryptedDataNoticeText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font12Weight600.copyWith(
                color: AppColorsManager.scaffoldBackGroundColor,
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
