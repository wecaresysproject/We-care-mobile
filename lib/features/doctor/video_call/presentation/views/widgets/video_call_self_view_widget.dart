import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// Floating self-view box (doctor's own camera) pinned to the top-right of
/// the video call screen, with a flip-camera control.
class VideoCallSelfViewWidget extends StatelessWidget {
  const VideoCallSelfViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 130.h,
      decoration: BoxDecoration(
        color: AppColorsManager.videoCallDoctorSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColorsManager.scaffoldBackGroundColor,
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/doctor_photo.png',
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 6.h,
            right: 6.w,
            child: Material(
              color: AppColorsManager.videoCallOverlayIconBackground,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(6.r),
                  child: Icon(
                    Icons.flip_camera_ios_outlined,
                    size: 14.r,
                    color: AppColorsManager.scaffoldBackGroundColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
