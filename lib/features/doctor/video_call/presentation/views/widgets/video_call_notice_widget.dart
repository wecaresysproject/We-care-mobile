import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// Status overlay covering the video surface until the doctor is inside the
/// room — an optional spinner, message and action button.
class VideoCallNoticeWidget extends StatelessWidget {
  const VideoCallNoticeWidget({
    super.key,
    this.message = '',
    this.isLoading = false,
    this.actionLabel,
    this.onActionPressed,
  });

  final String message;
  final bool isLoading;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final actionLabel = this.actionLabel;
    return ColoredBox(
      color: AppColorsManager.videoCallDoctorSurface,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColorsManager.scaffoldBackGroundColor,
                ),
              if (isLoading && message.isNotEmpty) SizedBox(height: 16.h),
              if (message.isNotEmpty)
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font14WhiteWeight700,
                ),
              if (actionLabel != null) ...[
                SizedBox(height: 14.h),
                TextButton(
                  onPressed: onActionPressed,
                  style: TextButton.styleFrom(
                    backgroundColor: AppColorsManager.scaffoldBackGroundColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 8.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  child: Text(
                    actionLabel,
                    style: AppTextStyles.font14WhiteWeight700.copyWith(
                      fontSize: 13.sp,
                      color: AppColorsManager.videoCallDoctorSurface,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
