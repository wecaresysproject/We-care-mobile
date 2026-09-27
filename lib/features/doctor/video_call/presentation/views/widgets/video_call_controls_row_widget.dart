import 'package:flutter/material.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/video_call/presentation/views/widgets/video_call_control_button_widget.dart';
import 'package:we_care/generated/l10n.dart';

/// The mic / camera / end-call / speaker control row at the bottom of the
/// video call screen. Mic/camera/speaker are local UI toggles only; ending
/// the call pops back to the bookings screen.
class VideoCallControlsRowWidget extends StatefulWidget {
  const VideoCallControlsRowWidget({super.key});

  @override
  State<VideoCallControlsRowWidget> createState() =>
      _VideoCallControlsRowWidgetState();
}

class _VideoCallControlsRowWidgetState
    extends State<VideoCallControlsRowWidget> {
  bool _isMicMuted = false;
  bool _isCameraOff = false;
  bool _isSpeakerOn = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: VideoCallControlButtonWidget(
            icon: _isMicMuted ? Icons.mic_off : Icons.mic,
            label: S.of(context).microphoneAction,
            onTap: () => setState(() => _isMicMuted = !_isMicMuted),
          ),
        ),
        Expanded(
          child: VideoCallControlButtonWidget(
            icon: _isCameraOff ? Icons.videocam_off : Icons.videocam,
            label: S.of(context).cameraAction,
            onTap: () => setState(() => _isCameraOff = !_isCameraOff),
          ),
        ),
        Expanded(
          child: VideoCallControlButtonWidget(
            icon: Icons.call_end,
            label: S.of(context).endExaminationAction,
            backgroundColor: AppColorsManager.videoCallEndButtonBackground,
            iconColor: AppColorsManager.scaffoldBackGroundColor,
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        Expanded(
          child: VideoCallControlButtonWidget(
            icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
            label: S.of(context).speakerAction,
            onTap: () => setState(() => _isSpeakerOn = !_isSpeakerOn),
          ),
        ),
      ],
    );
  }
}
