import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/logic/cubit/examination_call_cubit.dart';
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

  /// الطبيب (أو أى طرف تانى) موجود فى الغرفة.
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
    final participants = await _jitsiController.participantsCount();
    if (!mounted) return;
    setState(() => _isRemoteParticipantInRoom = participants > 1);
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

  //! ملخص الملف الطبى وأسئلة المستخدم أثناء المكالمة هيتفعلوا مع ربط الغرفة.
  void _onMedicalFilePressed() =>
      _showMessage("فتح ملفك الطبي أثناء $_typeName سيتوفر قريباً");

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
  _CallNotice? _noticeFor(ExaminationCallState state) {
    if (_hasMediaPermissions == false) {
      return _CallNotice(
        message: "يجب السماح باستخدام الكاميرا والميكروفون لبدء $_typeName",
        actionLabel: "فتح الإعدادات",
        onActionPressed: openAppSettings,
      );
    }
    switch (state.status) {
      case ExaminationCallStatus.loading:
        return const _CallNotice(isLoading: true);
      case ExaminationCallStatus.waitingForDoctor:
        return _CallNotice(
          message: "الطبيب لم يبدأ $_typeName بعد",
          isLoading: true,
        );
      case ExaminationCallStatus.ended:
        return _CallNotice(message: "انتهى $_typeName");
      case ExaminationCallStatus.failure:
        return _CallNotice(
          message: state.errorMessage,
          actionLabel: "إعادة المحاولة",
          onActionPressed: () => context
              .read<ExaminationCallCubit>()
              .loadMeeting(widget.booking.bookingId),
        );
      case ExaminationCallStatus.ready:
        if (_hasMediaPermissions == null || !_isJoined) {
          return const _CallNotice(isLoading: true);
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
                          displayName: "المريض",
                        ),
                      ),
                    // صورة الطبيب بتغطى الفيديو لحد ما المستخدم يدخل الغرفة.
                    if (notice != null)
                      Positioned.fill(
                        child: _CallPlaceholder(
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
                            child: _CallTopBar(
                              statusLabel: _statusLabelFor(state.status),
                              elapsedLabel: _elapsedLabel,
                            ),
                          ),
                          const Spacer(),
                          const _EncryptionChip(),
                          verticalSpacing(16),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: _CallControlsRow(
                              typeName: _typeName,
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

/// محتوى رسالة الحالة فوق الفيديو — نص اختيارى، مؤشر تحميل، وزرار اختيارى.
class _CallNotice {
  const _CallNotice({
    this.message = '',
    this.isLoading = false,
    this.actionLabel,
    this.onActionPressed,
  });

  final String message;
  final bool isLoading;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
}

/// صورة الطبيب معتمة وعليها رسالة الحالة — بتظهر لحد ما الفيديو يشتغل.
class _CallPlaceholder extends StatelessWidget {
  const _CallPlaceholder({required this.imageUrl, required this.notice});

  final String imageUrl;
  final _CallNotice notice;

  @override
  Widget build(BuildContext context) {
    final actionLabel = notice.actionLabel;
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              Container(color: const Color(0xFF2B2F33)),
          errorWidget: (context, url, error) =>
              Container(color: const Color(0xFF2B2F33)),
        ),
        ColoredBox(color: Colors.black.withValues(alpha: 0.6)),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (notice.isLoading)
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white.withAlpha(200),
                  ),
                if (notice.isLoading && notice.message.isNotEmpty)
                  verticalSpacing(16),
                if (notice.message.isNotEmpty)
                  Text(
                    notice.message,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font14whiteWeight600.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                if (actionLabel != null) ...[
                  verticalSpacing(14),
                  TextButton(
                    onPressed: notice.onActionPressed,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColorsManager.mainDarkBlue,
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
                      style: AppTextStyles.font14whiteWeight600.copyWith(
                        fontSize: 13.sp,
                        color: AppColorsManager.mainDarkBlue,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// شريط أعلى المكالمة — درع الأمان، شيب "الكشف جارى" والمؤقت، وزرار الخيارات.
class _CallTopBar extends StatelessWidget {
  const _CallTopBar({required this.statusLabel, required this.elapsedLabel});

  final String statusLabel;
  final String elapsedLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // أول عنصر بيترسم يمين فى الـ RTL — زرار الخيارات على الشمال زى التصميم.
        const _RoundGlassButton(icon: Icons.more_horiz_rounded),
        Expanded(
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 9.w,
                    height: 9.w,
                    decoration: const BoxDecoration(
                      color: OnlineDoctorTheme.consultationGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  horizontalSpacing(7),
                  Text(
                    statusLabel,
                    style: AppTextStyles.font14whiteWeight600.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  horizontalSpacing(8),
                  Text(
                    "|",
                    style: AppTextStyles.font14whiteWeight600.copyWith(
                      fontSize: 13.sp,
                      color: Colors.white.withAlpha(120),
                    ),
                  ),
                  horizontalSpacing(8),
                  Text(
                    elapsedLabel,
                    style: AppTextStyles.font14whiteWeight600.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const _RoundGlassButton(icon: Icons.shield_outlined),
      ],
    );
  }
}

/// زرار دائرى زجاجى غامق — شكلى لحد ما خيارات المكالمة تتحدد.
class _RoundGlassButton extends StatelessWidget {
  const _RoundGlassButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.w,
      height: 42.w,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20.sp, color: Colors.white),
    );
  }
}

/// شيب "جميع البيانات مشفرة وآمنة" فوق أزرار التحكم.
class _EncryptionChip extends StatelessWidget {
  const _EncryptionChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 13.sp,
            color: Colors.white,
          ),
          horizontalSpacing(5),
          Text(
            "جميع البيانات مشفرة وآمنة",
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// صف أزرار التحكم — ميكروفون وكاميرا وإنهاء ومكبر صوت.
class _CallControlsRow extends StatelessWidget {
  const _CallControlsRow({
    required this.typeName,
    required this.isMicOn,
    required this.isCameraOn,
    required this.isSpeakerOn,
    required this.onMicPressed,
    required this.onCameraPressed,
    required this.onSpeakerPressed,
    required this.onEndCallPressed,
  });

  final String typeName;
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _CallControlButton(
          icon: isMicOn ? Icons.mic_rounded : Icons.mic_off_rounded,
          label: "الميكروفون",
          isActive: isMicOn,
          onPressed: onMicPressed,
        ),
        _CallControlButton(
          icon:
              isCameraOn ? Icons.videocam_rounded : Icons.videocam_off_rounded,
          label: "الكاميرا",
          isActive: isCameraOn,
          onPressed: onCameraPressed,
        ),
        _CallControlButton(
          icon: Icons.call_end_rounded,
          label: "إنهاء $typeName",
          backgroundColor: OnlineDoctorTheme.offlineRed,
          contentColor: Colors.white,
          size: 64,
          onPressed: onEndCallPressed,
        ),
        _CallControlButton(
          icon:
              isSpeakerOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
          label: "مكبر الصوت",
          isActive: isSpeakerOn,
          onPressed: onSpeakerPressed,
        ),
      ],
    );
  }
}

/// زرار تحكم واحد — دايرة بيضا (أو حمرا للإنهاء) وتحتها التسمية،
/// وبيتعتم لما يكون مقفول.
class _CallControlButton extends StatelessWidget {
  const _CallControlButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isActive = true,
    this.backgroundColor,
    this.contentColor,
    this.size = 54,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isActive;
  final Color? backgroundColor;
  final Color? contentColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    final circleColor = backgroundColor ??
        (isActive ? Colors.white : Colors.white.withValues(alpha: 0.55));
    final iconColor = contentColor ??
        (isActive
            ? OnlineDoctorTheme.headingColor
            : OnlineDoctorTheme.offlineRed);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: circleColor,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: size.w,
              height: size.w,
              child: Icon(icon, size: (size * 0.42).sp, color: iconColor),
            ),
          ),
        ),
        verticalSpacing(7),
        Text(
          label,
          style: AppTextStyles.font12blackWeight400.copyWith(
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            shadows: const [
              Shadow(color: Colors.black54, blurRadius: 6),
            ],
          ),
        ),
      ],
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
