import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/video_call/presentation/views/widgets/video_call_actions_grid_widget.dart';
import 'package:we_care/features/doctor/video_call/presentation/views/widgets/video_call_stage_widget.dart';

/// Live consultation screen shown after the doctor allows a patient in from
/// the bookings screen. `elapsedLabel` is the running call timer (e.g.
/// "08:24"); the screen itself has no data dependency beyond that.
class VideoCallView extends StatelessWidget {
  const VideoCallView({super.key, this.elapsedLabel = '00:00'});

  final String elapsedLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsManager.videoCallPatientSurface,
      // Reference design lays this screen out at fixed physical positions,
      // not mirrored for Arabic — see the Home screen's Directionality wrap
      // for the full rationale.
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            Expanded(child: VideoCallStageWidget(elapsedLabel: elapsedLabel)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h),
              decoration: BoxDecoration(
                color: AppColorsManager.videoCallSheetBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: SafeArea(
                top: false,
                child: const VideoCallActionsGridWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
