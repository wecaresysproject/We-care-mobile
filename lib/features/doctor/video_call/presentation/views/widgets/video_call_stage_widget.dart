import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/video_call/presentation/views/widgets/video_call_controls_row_widget.dart';
import 'package:we_care/features/doctor/video_call/presentation/views/widgets/video_call_encryption_notice_widget.dart';
import 'package:we_care/features/doctor/video_call/presentation/views/widgets/video_call_self_view_widget.dart';
import 'package:we_care/features/doctor/video_call/presentation/views/widgets/video_call_top_bar_widget.dart';

/// Full-bleed patient camera surface with the top bar, self-view box,
/// encryption notice and in-call controls layered above it.
class VideoCallStageWidget extends StatelessWidget {
  const VideoCallStageWidget({super.key, required this.elapsedLabel});

  final String elapsedLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColorsManager.videoCallPatientSurface,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/doctor_photo.png', fit: BoxFit.cover),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Stack(
                children: [
                  VideoCallTopBarWidget(elapsedLabel: elapsedLabel),
                  Positioned(
                    top: 70.h,
                    right: 0,
                    child: const VideoCallSelfViewWidget(),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 90.h,
                    child: const Center(
                      child: VideoCallEncryptionNoticeWidget(),
                    ),
                  ),
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 12,
                    child: VideoCallControlsRowWidget(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
