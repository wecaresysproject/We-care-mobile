import 'package:flutter/material.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/video_call/presentation/views/widgets/video_call_control_button_widget.dart';
import 'package:we_care/generated/l10n.dart';

/// The mic / camera / end-call / speaker control row at the bottom of the
/// video call screen. Mic and camera mirror the live Jitsi room state; the
/// speaker is a local UI toggle only.
class VideoCallControlsRowWidget extends StatelessWidget {
  const VideoCallControlsRowWidget({
    super.key,
    required this.isMicOn,
    required this.isCameraOn,
    required this.isSpeakerOn,
    required this.onMicPressed,
    required this.onCameraPressed,
    required this.onSpeakerPressed,
    required this.onEndCallPressed,
  });

  final bool isMicOn;
  final bool isCameraOn;
  final bool isSpeakerOn;
  final VoidCallback onMicPressed;
  final VoidCallback onCameraPressed;
  final VoidCallback onSpeakerPressed;
  final VoidCallback onEndCallPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: VideoCallControlButtonWidget(
            icon: isMicOn ? Icons.mic : Icons.mic_off,
            label: S.of(context).microphoneAction,
            onTap: onMicPressed,
          ),
        ),
        Expanded(
          child: VideoCallControlButtonWidget(
            icon: isCameraOn ? Icons.videocam : Icons.videocam_off,
            label: S.of(context).cameraAction,
            onTap: onCameraPressed,
          ),
        ),
        Expanded(
          child: VideoCallControlButtonWidget(
            icon: Icons.call_end,
            label: S.of(context).endExaminationAction,
            backgroundColor: AppColorsManager.videoCallEndButtonBackground,
            iconColor: AppColorsManager.scaffoldBackGroundColor,
            onTap: onEndCallPressed,
          ),
        ),
        Expanded(
          child: VideoCallControlButtonWidget(
            icon: isSpeakerOn ? Icons.volume_up : Icons.volume_off,
            label: S.of(context).speakerAction,
            onTap: onSpeakerPressed,
          ),
        ),
      ],
    );
  }
}
