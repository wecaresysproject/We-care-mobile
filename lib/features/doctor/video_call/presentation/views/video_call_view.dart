import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/networking/models/care_context_manager_model.dart';
import 'package:we_care/features/doctor/patient_medical_file/presentation/patient_medical_file_launcher.dart';
import 'package:we_care/features/doctor/video_call/logic/cubit/doctor_video_call_cubit.dart';
import 'package:we_care/features/doctor/video_call/presentation/views/widgets/video_call_actions_grid_widget.dart';
import 'package:we_care/features/doctor/video_call/presentation/views/widgets/video_call_controls_row_widget.dart';
import 'package:we_care/features/doctor/video_call/presentation/views/widgets/video_call_notice_widget.dart';
import 'package:we_care/features/doctor/video_call/presentation/views/widgets/video_call_stage_widget.dart';
import 'package:we_care/features/online_doctor/data/models/call_participant_role.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/jitsi_meeting_view.dart';
import 'package:we_care/features/online_doctor/video_call_logger.dart';
import 'package:we_care/generated/l10n.dart';

/// Live consultation screen shown after the doctor allows a patient in from
/// the bookings screen. Opens the Jitsi room of [appointmentId] once
/// [DoctorVideoCallCubit] has created and started its meeting.
class VideoCallView extends StatefulWidget {
  const VideoCallView({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  State<VideoCallView> createState() => _VideoCallViewState();
}

class _VideoCallViewState extends State<VideoCallView> {
  final JitsiMeetingController _jitsiController = JitsiMeetingController();

  /// Call duration — counts from the moment the doctor is inside the room.
  Timer? _callTicker;
  Duration _elapsed = Duration.zero;

  /// Null until the user answers the camera/microphone request.
  bool? _hasMediaPermissions;

  /// The doctor is inside the Jitsi room (`videoConferenceJoined`).
  bool _isJoined = false;

  bool _isPatientInRoom = false;
  bool _isMicOn = true;
  bool _isCameraOn = true;

  // Local UI toggle only — a web page cannot switch the audio output on
  // mobile.
  bool _isSpeakerOn = true;

  /// Guards against a second end request while one is in flight.
  bool _isEnding = false;

  /// The doctor asked to leave the room — `videoConferenceLeft` then closes
  /// the screen instead of waiting for Jitsi to reconnect.
  bool _isHangingUp = false;

  @override
  void initState() {
    super.initState();
    VideoCallLogger.info(
      'doctor call screen opened → appointmentId=${widget.appointmentId}',
    );
    _requestMediaPermissions();
  }

  @override
  void dispose() {
    _callTicker?.cancel();
    // Never leave the patient's file open once the call screen is gone.
    if (CareContextManager.isDoctorAccess) CareContextManager.exit();
    VideoCallLogger.info(
      'doctor call screen closed → joined=$_isJoined elapsed=$_elapsedLabel',
    );
    super.dispose();
  }

  Future<void> _requestMediaPermissions() async {
    final isGranted = await requestCallMediaPermissions();
    if (!mounted) return;
    setState(() => _hasMediaPermissions = isGranted);
  }

  /// "08:24" — the hours show once the call passes one hour.
  String get _elapsedLabel {
    final minutes = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    if (_elapsed.inHours > 0) return "${_elapsed.inHours}:$minutes:$seconds";
    return "$minutes:$seconds";
  }

  String _statusLabelFor(DoctorVideoCallStatus status) {
    if (status == DoctorVideoCallStatus.ended) return "انتهى الكشف";
    if (!_isJoined) return "جاري الاتصال";
    if (!_isPatientInRoom) return "في انتظار المريض";
    return S.of(context).examinationInProgressLabel;
  }

  void _onJitsiEvent(String name, Map<String, dynamic> data) {
    if (!mounted) return;

    switch (name) {
      case 'videoConferenceJoined':
        _callTicker?.cancel();
        _callTicker = Timer.periodic(
          const Duration(seconds: 1),
          (_) => setState(() => _elapsed += const Duration(seconds: 1)),
        );
        setState(() => _isJoined = true);
        _refreshPatientPresence();
      case 'participantJoined':
      case 'participantLeft':
        _refreshPatientPresence();
      case 'audioMuteStatusChanged':
        setState(() => _isMicOn = data['muted'] != true);
      case 'videoMuteStatusChanged':
        setState(() => _isCameraOn = data['muted'] != true);
      case 'externalApiLoadFailed':
        showError("تعذر الاتصال بخادم المكالمة");
      case 'cameraError':
        showError("تعذر تشغيل الكاميرا");
      case 'micError':
        showError("تعذر تشغيل الميكروفون");
      case 'videoConferenceLeft':
        _onConferenceLeft();
      case 'readyToClose':
        _closeScreen();
    }
  }

  /// Jitsi also leaves the room when the connection drops, then reloads and
  /// joins again on its own — only a hangup closes the screen.
  void _onConferenceLeft() {
    if (_isHangingUp) {
      _closeScreen();
      return;
    }
    VideoCallLogger.warning('left room unexpectedly → waiting to rejoin');
    setState(() {
      _isJoined = false;
      _isPatientInRoom = false;
    });
  }

  Future<void> _refreshPatientPresence() async {
    // المشاركين ممكن يدخلوا قبل المريض — الحالة بتستنى المريض نفسه.
    final isPatientInRoom = await _jitsiController.hasParticipantWithRole(
      CallParticipantRole.patient,
    );
    if (!mounted) return;
    setState(() => _isPatientInRoom = isPatientInRoom);
  }

  void _runJitsiCommand(String command) {
    if (!_isJoined) return;
    _jitsiController.runCommand(command);
  }

  /// Ending is final for the appointment — the patient side shows the
  /// examination as ended — so it is confirmed first.
  Future<void> _onEndCallPressed() async {
    VideoCallLogger.info('doctor end call pressed → joined=$_isJoined');
    final status = context.read<DoctorVideoCallCubit>().state.status;
    if (status != DoctorVideoCallStatus.ready) {
      _closeScreen();
      return;
    }
    if (_isEnding) return;

    final isConfirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("إنهاء الكشف"),
        content: const Text("سيتم إنهاء الكشف للمريض أيضاً. هل أنت متأكد؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text("إنهاء"),
          ),
        ],
      ),
    );
    VideoCallLogger.info('doctor end call confirmed → $isConfirmed');
    if (isConfirmed != true || !mounted) return;

    _isEnding = true;
    final errorMessage =
        await context.read<DoctorVideoCallCubit>().endMeeting();
    _isEnding = false;
    if (!mounted) return;
    if (errorMessage != null) {
      showError(errorMessage);
      return;
    }

    if (_isJoined) {
      // Leaving completes from the `videoConferenceLeft` event.
      _isHangingUp = true;
      _runJitsiCommand('hangup');
      return;
    }
    _closeScreen();
  }

  void _closeScreen() {
    if (!mounted || !(ModalRoute.of(context)?.isCurrent ?? false)) return;
    Navigator.of(context).pop();
  }

  /// The overlay covering the video until the doctor is inside the room —
  /// null once the video is showing.
  Widget? _noticeFor(DoctorVideoCallState state) {
    if (_hasMediaPermissions == false) {
      return const VideoCallNoticeWidget(
        message: "يجب السماح باستخدام الكاميرا والميكروفون لبدء الكشف",
        actionLabel: "فتح الإعدادات",
        onActionPressed: openAppSettings,
      );
    }
    switch (state.status) {
      case DoctorVideoCallStatus.loading:
        return const VideoCallNoticeWidget(isLoading: true);
      case DoctorVideoCallStatus.ended:
        return const VideoCallNoticeWidget(message: "انتهى الكشف");
      case DoctorVideoCallStatus.failure:
        return VideoCallNoticeWidget(
          message: state.message,
          actionLabel: "إعادة المحاولة",
          onActionPressed: () => context
              .read<DoctorVideoCallCubit>()
              .openMeeting(widget.appointmentId),
        );
      case DoctorVideoCallStatus.ready:
        if (_hasMediaPermissions == null || !_isJoined) {
          return const VideoCallNoticeWidget(isLoading: true);
        }
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsManager.videoCallDoctorSurface,
      // Reference design lays this screen out at fixed physical positions,
      // not mirrored for Arabic — see the Home screen's Directionality wrap
      // for the full rationale.
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<DoctorVideoCallCubit, DoctorVideoCallState>(
                builder: (context, state) {
                  final meeting = state.meeting;
                  final canOpenRoom =
                      state.status == DoctorVideoCallStatus.ready &&
                          meeting != null &&
                          _hasMediaPermissions == true;

                  return VideoCallStageWidget(
                    statusLabel: _statusLabelFor(state.status),
                    elapsedLabel: _elapsedLabel,
                    video: canOpenRoom
                        ? JitsiMeetingView(
                            meeting: meeting,
                            controller: _jitsiController,
                            onEvent: _onJitsiEvent,
                            displayName: CallParticipantRole.doctor
                                .displayNameFor(meeting.displayName),
                          )
                        : null,
                    notice: _noticeFor(state),
                    controls: VideoCallControlsRowWidget(
                      isMicOn: _isMicOn,
                      isCameraOn: _isCameraOn,
                      isSpeakerOn: _isSpeakerOn,
                      onMicPressed: () => _runJitsiCommand('toggleAudio'),
                      onCameraPressed: () => _runJitsiCommand('toggleVideo'),
                      onSpeakerPressed: () =>
                          setState(() => _isSpeakerOn = !_isSpeakerOn),
                      onEndCallPressed: _onEndCallPressed,
                    ),
                  );
                },
              ),
            ),
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
                child: VideoCallActionsGridWidget(
                  onMedicalFileTap: () => PatientMedicalFileLauncher.open(
                    context,
                    bookingId: widget.appointmentId,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
