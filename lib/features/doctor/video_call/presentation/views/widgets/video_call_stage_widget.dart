import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/video_call/presentation/views/widgets/video_call_controls_row_widget.dart';
import 'package:we_care/features/doctor/video_call/presentation/views/widgets/video_call_encryption_notice_widget.dart';
import 'package:we_care/features/doctor/video_call/presentation/views/widgets/video_call_top_bar_widget.dart';

/// Full-bleed video surface with the top bar, encryption notice and in-call
/// controls layered above it. [video] is the live room; [notice] covers it
/// until the doctor is inside the room.
class VideoCallStageWidget extends StatelessWidget {
  const VideoCallStageWidget({
    super.key,
    required this.statusLabel,
    required this.elapsedLabel,
    required this.controls,
    this.video,
    this.notice,
  });

  final String statusLabel;
  final String elapsedLabel;
  final VideoCallControlsRowWidget controls;
  final Widget? video;
  final Widget? notice;

  @override
  Widget build(BuildContext context) {
    final video = this.video;
    final notice = this.notice;
    return Container(
      color: AppColorsManager.videoCallDoctorSurface,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (video != null) video,
          if (notice != null) notice,
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Stack(
                children: [
                  VideoCallTopBarWidget(
                    statusLabel: statusLabel,
                    elapsedLabel: elapsedLabel,
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 90.h,
                    child: const Center(
                      child: VideoCallEncryptionNoticeWidget(),
                    ),
                  ),
                  Positioned(left: 0, right: 0, bottom: 12, child: controls),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
