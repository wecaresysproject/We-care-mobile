import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/data/models/call_participant_role.dart';
import 'package:we_care/features/online_doctor/logic/cubit/examination_call_cubit.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/call_screen_widgets.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/jitsi_meeting_view.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';
import 'package:we_care/features/online_doctor/video_call_logger.dart';

/// شاشة مكالمة الكشف — فيديو Jitsi جوه WebView، شريط الحالة والمؤقت فوق،
/// أزرار التحكم فى المكالمة، وكارتى "ملفى الطبى" و"أسئلتى للطبيب" تحت.
class ExaminationCallView extends StatefulWidget {
  const ExaminationCallView({super.key, required this.booking});

  final BookingModel booking;

  @override
  State<ExaminationCallView> createState() => _ExaminationCallViewState();
}

class _ExaminationCallViewState extends State<ExaminationCallView> {
  final JitsiMeetingController _jitsiController = JitsiMeetingController();

  /// مؤقت مدة المكالمة — بيعد من لحظة دخول الغرفة فعلياً.
  Timer? _callTicker;
  Duration _elapsed = Duration.zero;

  /// `null` لحد ما المستخدم يرد على طلب الكاميرا والميكروفون.
  bool? _hasMediaPermissions;

  /// المستخدم دخل غرفة Jitsi فعلياً (`videoConferenceJoined`).
  bool _isJoined = false;

  /// الطبيب موجود فى الغرفة.
  bool _isRemoteParticipantInRoom = false;

  bool _isMicOn = true;
  bool _isCameraOn = true;

  //! مكبر الصوت شكلى — صفحة الويب متقدرش تغيّر مخرج الصوت على الموبايل.
  bool _isSpeakerOn = true;

  /// المستخدم طلب الخروج — `videoConferenceLeft` ساعتها يقفل الشاشة بدل ما
  /// يستنى Jitsi يرجع يتصل.
  bool _isHangingUp = false;

  @override
  void initState() {
    super.initState();
    VideoCallLogger.info(
      'call screen opened → bookingId=${widget.booking.bookingId}',
    );
    _requestMediaPermissions();
  }

  @override
  void dispose() {
    _callTicker?.cancel();
    VideoCallLogger.info(
      'call screen closed → joined=$_isJoined elapsed=$_elapsedLabel',
    );
    super.dispose();
  }

  Future<void> _requestMediaPermissions() async {
    final isGranted = await requestCallMediaPermissions();
    if (!mounted) return;
    setState(() => _hasMediaPermissions = isGranted);
  }

  String get _typeName => widget.booking.type.shortName;

  /// "08:24" — وبتظهر الساعات لو المكالمة عدت ساعة.
  String get _elapsedLabel {
    final minutes = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    if (_elapsed.inHours > 0) return "${_elapsed.inHours}:$minutes:$seconds";
    return "$minutes:$seconds";
  }

  String _statusLabelFor(ExaminationCallStatus status) {
    if (status == ExaminationCallStatus.waitingForDoctor) {
      return "في انتظار الطبيب";
    }
    if (status == ExaminationCallStatus.ended) return "انتهى $_typeName";
    if (!_isJoined) return "جاري الاتصال";
    if (!_isRemoteParticipantInRoom) return "في انتظار الطبيب";
    return widget.booking.type.isExamination ? "الكشف جاري" : "الاستشارة جارية";
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
        _refreshRemoteParticipants();
      case 'participantJoined':
      case 'participantLeft':
        _refreshRemoteParticipants();
      case 'audioMuteStatusChanged':
        setState(() => _isMicOn = data['muted'] != true);
      case 'videoMuteStatusChanged':
        setState(() => _isCameraOn = data['muted'] != true);
      case 'externalApiLoadFailed':
        _showMessage("تعذر الاتصال بخادم المكالمة");
      case 'cameraError':
        _showMessage("تعذر تشغيل الكاميرا");
      case 'micError':
        _showMessage("تعذر تشغيل الميكروفون");
      case 'videoConferenceLeft':
        _onConferenceLeft();
      case 'readyToClose':
        _closeScreen();
    }
  }

  /// Jitsi بيخرج من الغرفة كمان لما الاتصال يقع، وبعدين يعمل reload ويدخل
  /// تانى لوحده — الشاشة متتقفلش غير لما المستخدم ينهى المكالمة.
  void _onConferenceLeft() {
    if (_isHangingUp) {
      _closeScreen();
      return;
    }
    VideoCallLogger.warning('left room unexpectedly → waiting to rejoin');
    setState(() {
      _isJoined = false;
      _isRemoteParticipantInRoom = false;
    });
  }

  Future<void> _refreshRemoteParticipants() async {
    // المشاركين ممكن يدخلوا قبل الطبيب — الحالة بتستنى الطبيب نفسه.
    final isDoctorInRoom = await _jitsiController.hasParticipantWithRole(
      CallParticipantRole.doctor,
    );
    if (!mounted) return;
    setState(() => _isRemoteParticipantInRoom = isDoctorInRoom);
  }

  void _runJitsiCommand(String command) {
    if (!_isJoined) return;
    _jitsiController.runCommand(command);
  }

  void _onEndCallPressed() {
    VideoCallLogger.info('end call pressed → joined=$_isJoined');
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

  /// Opens the patient's own medical file on top of the call, so the call
  /// keeps running underneath and back returns to it.
  void _onMedicalFilePressed() =>
      Navigator.of(context).pushNamed(Routes.medicalCategoriesTypesView);

  //! أسئلة المستخدم أثناء المكالمة هتتفعل مع ربط الغرفة.

  void _onQuestionsPressed() =>
      _showMessage("مراجعة أسئلتك أثناء $_typeName ستتوفر قريباً");

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColorsManager.mainDarkBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.font14whiteWeight600.copyWith(
              fontSize: 12.5.sp,
            ),
          ),
        ),
      );
  }

  /// رسالة الحالة اللى بتغطى الفيديو لحد ما المستخدم يدخل الغرفة — `null`
  /// لما الفيديو يبقى ظاهر.
  CallNotice? _noticeFor(ExaminationCallState state) {
    if (_hasMediaPermissions == false) {
      return CallNotice(
        message: "يجب السماح باستخدام الكاميرا والميكروفون لبدء $_typeName",
        actionLabel: "فتح الإعدادات",
        onActionPressed: openAppSettings,
      );
    }
    switch (state.status) {
      case ExaminationCallStatus.loading:
        return const CallNotice(isLoading: true);
      case ExaminationCallStatus.waitingForDoctor:
        return CallNotice(
          message: "الطبيب لم يبدأ $_typeName بعد",
          isLoading: true,
        );
      case ExaminationCallStatus.ended:
        return CallNotice(message: "انتهى $_typeName");
      case ExaminationCallStatus.failure:
        return CallNotice(
          message: state.errorMessage,
          actionLabel: "إعادة المحاولة",
          onActionPressed: () => context
              .read<ExaminationCallCubit>()
              .loadMeeting(widget.booking.bookingId),
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

          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    if (canOpenRoom)
                      Positioned.fill(
                        child: JitsiMeetingView(
                          meeting: meeting,
                          controller: _jitsiController,
                          onEvent: _onJitsiEvent,
                          displayName: CallParticipantRole.patient
                              .displayNameFor(meeting.displayName),
                        ),
                      ),
                    // صورة الطبيب بتغطى الفيديو لحد ما المستخدم يدخل الغرفة.
                    if (notice != null)
                      Positioned.fill(
                        child: CallPlaceholder(
                          imageUrl: widget.booking.doctor.imageUrl,
                          notice: notice,
                        ),
                      ),
                    // تظليل خفيف عشان أزرار التحكم والتسميات البيضا تبان —
                    // من غير ما يمنع اللمس عن الفيديو.
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
                      bottom: false,
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
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: CallControlsRow(
                              endCallLabel: "إنهاء $_typeName",
                              isMicOn: _isMicOn,
                              isCameraOn: _isCameraOn,
                              isSpeakerOn: _isSpeakerOn,
                              onMicPressed: () =>
                                  _runJitsiCommand('toggleAudio'),
                              onCameraPressed: () =>
                                  _runJitsiCommand('toggleVideo'),
                              onSpeakerPressed: () => setState(
                                () => _isSpeakerOn = !_isSpeakerOn,
                              ),
                              onEndCallPressed: _onEndCallPressed,
                            ),
                          ),
                          verticalSpacing(14),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _CallBottomPanel(
                onMedicalFilePressed: _onMedicalFilePressed,
                onQuestionsPressed: _onQuestionsPressed,
              ),
            ],
          );
        },
      ),
    );
  }
}

/// اللوحة البيضا تحت — كارتى "ملفى الطبى" و"أسئلتى للطبيب".
class _CallBottomPanel extends StatelessWidget {
  const _CallBottomPanel({
    required this.onMedicalFilePressed,
    required this.onQuestionsPressed,
  });

  final VoidCallback onMedicalFilePressed;
  final VoidCallback onQuestionsPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _CallShortcutCard(
                    title: "ملفي الطبي",
                    description:
                        "الوصول إلى جميع بياناتك الطبية من تحاليل وأشعة وأدوية وغيرها",
                    icon: Icons.folder_shared_rounded,
                    accentColor: OnlineDoctorTheme.consultationGreen,
                    surfaceColor: OnlineDoctorTheme.consultationSurface,
                    onPressed: onMedicalFilePressed,
                  ),
                ),
                horizontalSpacing(10),
                Expanded(
                  child: _CallShortcutCard(
                    title: "أسئلتي للطبيب",
                    description:
                        "مراجعة الأسئلة التي أضفتها ومتابعة ما تم مناقشه",
                    icon: Icons.quiz_rounded,
                    accentColor: OnlineDoctorTheme.accentBlue,
                    surfaceColor: OnlineDoctorTheme.iconTint,
                    onPressed: onQuestionsPressed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// كارت اختصار واحد فى لوحة المكالمة — أيقونة وعنوان ووصف وسهم.
class _CallShortcutCard extends StatelessWidget {
  const _CallShortcutCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.surfaceColor,
    required this.onPressed,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final Color surfaceColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
          child: Column(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Icon(icon, size: 22.sp, color: Colors.white),
              ),
              verticalSpacing(8),
              Text(
                title,
                style: AppTextStyles.font14blackWeight400.copyWith(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                ),
              ),
              verticalSpacing(4),
              Text(
                description,
                textAlign: TextAlign.center,
                style: AppTextStyles.font12blackWeight400.copyWith(
                  fontSize: 10.5.sp,
                  height: 1.5,
                  color: OnlineDoctorTheme.mutedText,
                ),
              ),
              const Spacer(),
              verticalSpacing(8),
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                // سهم "التقدم" فى الـ RTL بيشاور شمال — ده جليف arrow_back.
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 15.sp,
                  color: accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
