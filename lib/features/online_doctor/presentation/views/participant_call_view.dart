import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/online_doctor/data/models/call_participant_role.dart';
import 'package:we_care/features/online_doctor/logic/cubit/examination_call_cubit.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/call_screen_widgets.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/jitsi_meeting_view.dart';
import 'package:we_care/features/online_doctor/video_call_logger.dart';

/// شاشة مكالمة الشخص المقرب اللى المريض ضافه للاستشارة — الفيديو والتحكم
/// فى الكاميرا والميكروفون وزرار الخروج بس، من غير الملف الطبى أو الأسئلة.
class ParticipantCallView extends StatefulWidget {
  const ParticipantCallView({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  State<ParticipantCallView> createState() => _ParticipantCallViewState();
}

class _ParticipantCallViewState extends State<ParticipantCallView> {
  final JitsiMeetingController _jitsiController = JitsiMeetingController();

  /// مؤقت مدة المكالمة — بيعد من لحظة دخول الغرفة فعلياً.
  Timer? _callTicker;
  Duration _elapsed = Duration.zero;

  /// `null` لحد ما المستخدم يرد على طلب الكاميرا والميكروفون.
  bool? _hasMediaPermissions;

  /// المستخدم دخل غرفة Jitsi فعلياً (`videoConferenceJoined`).
  bool _isJoined = false;
  bool _isDoctorInRoom = false;
  bool _isMicOn = true;
  bool _isCameraOn = true;

  /// المستخدم طلب الخروج — `videoConferenceLeft` ساعتها يقفل الشاشة بدل ما
  /// يستنى Jitsi يرجع يتصل.
  bool _isHangingUp = false;

  @override
  void initState() {
    super.initState();
    VideoCallLogger.info(
      'participant call opened → appointmentId=${widget.appointmentId}',
    );
    _requestMediaPermissions();
  }

  @override
  void dispose() {
    _callTicker?.cancel();
    VideoCallLogger.info('participant call closed → joined=$_isJoined');
    super.dispose();
  }

  Future<void> _requestMediaPermissions() async {
    final isGranted = await requestCallMediaPermissions();
    if (!mounted) return;
    setState(() => _hasMediaPermissions = isGranted);
  }

  /// "08:24" — وبتظهر الساعات لو المكالمة عدت ساعة.
  String get _elapsedLabel {
    final minutes = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    if (_elapsed.inHours > 0) return "${_elapsed.inHours}:$minutes:$seconds";
    return "$minutes:$seconds";
  }

  String _statusLabelFor(ExaminationCallStatus status) {
    if (status == ExaminationCallStatus.waitingForDoctor) {
      return "في انتظار بدء الاستشارة";
    }
    if (status == ExaminationCallStatus.ended) return "انتهت الاستشارة";
    if (!_isJoined) return "جاري الاتصال";
    if (!_isDoctorInRoom) return "في انتظار الطبيب";
    return "الاستشارة جارية";
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
        _refreshDoctorPresence();
      case 'participantJoined':
      case 'participantLeft':
        _refreshDoctorPresence();
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

  /// Jitsi بيخرج من الغرفة كمان لما الاتصال يقع، وبعدين يدخل تانى لوحده —
  /// الشاشة متتقفلش غير لما المستخدم يخرج.
  void _onConferenceLeft() {
    if (_isHangingUp) {
      _closeScreen();
      return;
    }
    VideoCallLogger.warning('left room unexpectedly → waiting to rejoin');
    setState(() {
      _isJoined = false;
      _isDoctorInRoom = false;
    });
  }

  Future<void> _refreshDoctorPresence() async {
    final isDoctorInRoom = await _jitsiController.hasParticipantWithRole(
      CallParticipantRole.doctor,
    );
    if (!mounted) return;
    setState(() => _isDoctorInRoom = isDoctorInRoom);
  }

  void _runJitsiCommand(String command) {
    if (!_isJoined) return;
    _jitsiController.runCommand(command);
  }

  void _onLeavePressed() {
    VideoCallLogger.info('participant leave pressed → joined=$_isJoined');
    if (_isJoined) {
      // الخروج بيكمل من حدث `videoConferenceLeft`.
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

  /// رسالة الحالة اللى بتغطى الفيديو لحد ما المستخدم يدخل الغرفة — `null`
  /// لما الفيديو يبقى ظاهر.
  CallNotice? _noticeFor(ExaminationCallState state) {
    if (_hasMediaPermissions == false) {
      return const CallNotice(
        message: "يجب السماح باستخدام الكاميرا والميكروفون للانضمام",
        actionLabel: "فتح الإعدادات",
        onActionPressed: openAppSettings,
      );
    }
    switch (state.status) {
      case ExaminationCallStatus.loading:
        return const CallNotice(isLoading: true);
      case ExaminationCallStatus.waitingForDoctor:
        return const CallNotice(
          message: "الطبيب لم يبدأ الاستشارة بعد",
          isLoading: true,
        );
      case ExaminationCallStatus.ended:
        return const CallNotice(message: "انتهت الاستشارة");
      case ExaminationCallStatus.failure:
        return CallNotice(
          message: state.errorMessage,
          actionLabel: "إعادة المحاولة",
          onActionPressed: () => context
              .read<ExaminationCallCubit>()
              .loadMeeting(widget.appointmentId),
        );
      case ExaminationCallStatus.ready:
        if (_hasMediaPermissions == null || !_isJoined) {
          return const CallNotice(isLoading: true);
        }
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<ExaminationCallCubit, ExaminationCallState>(
        builder: (context, state) {
          final meeting = state.meeting;
          final canOpenRoom = state.status == ExaminationCallStatus.ready &&
              meeting != null &&
              _hasMediaPermissions == true;
          final notice = _noticeFor(state);

          return Stack(
            children: [
              if (canOpenRoom)
                Positioned.fill(
                  child: JitsiMeetingView(
                    meeting: meeting,
                    controller: _jitsiController,
                    onEvent: _onJitsiEvent,
                    displayName: CallParticipantRole.participant
                        .displayNameFor(meeting.displayName),
                    // الطبيب أو المريض كبير حسب مين بيتكلم، والمشاركين
                    // صغيرين.
                    stageRoles: const [
                      CallParticipantRole.doctor,
                      CallParticipantRole.patient,
                    ],
                    followSpeaker: true,
                  ),
                ),
              if (notice != null)
                Positioned.fill(
                  child: CallPlaceholder(imageUrl: '', notice: notice),
                ),
              // تظليل خفيف عشان أزرار التحكم والتسميات البيضا تبان — من غير
              // ما يمنع اللمس عن الفيديو.
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.25),
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.35),
                        ],
                        stops: const [0, 0.2, 0.65, 1],
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
                      child: CallTopBar(
                        statusLabel: _statusLabelFor(state.status),
                        elapsedLabel: _elapsedLabel,
                      ),
                    ),
                    const Spacer(),
                    const EncryptionChip(),
                    verticalSpacing(16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 48.w),
                      child: CallControlsRow(
                        endCallLabel: "خروج",
                        isMicOn: _isMicOn,
                        isCameraOn: _isCameraOn,
                        onMicPressed: () => _runJitsiCommand('toggleAudio'),
                        onCameraPressed: () => _runJitsiCommand('toggleVideo'),
                        onEndCallPressed: _onLeavePressed,
                      ),
                    ),
                    verticalSpacing(20),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
