import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// شاشة مكالمة الكشف — فيديو الطبيب بملء الشاشة، شريط الحالة والمؤقت فوق،
/// معاينة كاميرا المستخدم، أزرار التحكم فى المكالمة، وكارتى "ملفى الطبى"
/// و"أسئلتى للطبيب" تحت.
class ExaminationCallView extends StatefulWidget {
  const ExaminationCallView({super.key, required this.booking});

  final BookingModel booking;

  @override
  State<ExaminationCallView> createState() => _ExaminationCallViewState();
}

class _ExaminationCallViewState extends State<ExaminationCallView> {
  //! صورة المستخدم فى معاينة الكاميرا dummy لحد ما بث الفيديو الفعلى يتربط.
  static const String _patientImageUrl =
      "https://randomuser.me/api/portraits/women/44.jpg";

  /// مؤقت مدة المكالمة — بيعد من لحظة الدخول.
  Timer? _callTicker;
  Duration _elapsed = Duration.zero;

  bool _isMicOn = true;
  bool _isCameraOn = true;
  bool _isSpeakerOn = true;

  @override
  void initState() {
    super.initState();
    _callTicker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _elapsed += const Duration(seconds: 1)),
    );
  }

  @override
  void dispose() {
    _callTicker?.cancel();
    super.dispose();
  }

  String get _typeName => widget.booking.type.shortName;

  /// "08:24" — وبتظهر الساعات لو المكالمة عدت ساعة.
  String get _elapsedLabel {
    final minutes = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    if (_elapsed.inHours > 0) return "${_elapsed.inHours}:$minutes:$seconds";
    return "$minutes:$seconds";
  }

  String get _statusLabel =>
      widget.booking.type.isExamination ? "الكشف جاري" : "الاستشارة جارية";

  void _onEndCallPressed() => Navigator.of(context).pop();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // فيديو الطبيب — صورته بملء الشاشة لحد ما بث الفيديو الفعلى يتربط.
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: widget.booking.doctor.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: const Color(0xFF2B2F33),
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white.withAlpha(150),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: const Color(0xFF2B2F33),
                alignment: Alignment.center,
                child: Icon(
                  Icons.videocam_off_rounded,
                  size: 48.sp,
                  color: Colors.white.withAlpha(120),
                ),
              ),
            ),
          ),
          // تظليل خفيف تحت عشان أزرار التحكم والتسميات البيضا تبان.
          Positioned.fill(
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
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
                  child: _CallTopBar(
                    statusLabel: _statusLabel,
                    elapsedLabel: _elapsedLabel,
                  ),
                ),
                verticalSpacing(14),
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _SelfPreviewCard(
                      imageUrl: _patientImageUrl,
                      isCameraOn: _isCameraOn,
                    ),
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
                    onMicPressed: () => setState(() => _isMicOn = !_isMicOn),
                    onCameraPressed: () =>
                        setState(() => _isCameraOn = !_isCameraOn),
                    onSpeakerPressed: () =>
                        setState(() => _isSpeakerOn = !_isSpeakerOn),
                    onEndCallPressed: _onEndCallPressed,
                  ),
                ),
                verticalSpacing(14),
                _CallBottomPanel(
                  onMedicalFilePressed: _onMedicalFilePressed,
                  onQuestionsPressed: _onQuestionsPressed,
                ),
              ],
            ),
          ),
        ],
      ),
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

/// معاينة كاميرا المستخدم — كارت صغير فى الركن، وبيتعتم لما الكاميرا تتقفل.
class _SelfPreviewCard extends StatelessWidget {
  const _SelfPreviewCard({required this.imageUrl, required this.isCameraOn});

  final String imageUrl;
  final bool isCameraOn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104.w,
      height: 138.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF2B2F33),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Stack(
        children: [
          if (isCameraOn)
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: const Color(0xFF2B2F33)),
                errorWidget: (context, url, error) => Icon(
                  Icons.person_rounded,
                  size: 40.sp,
                  color: Colors.white.withAlpha(120),
                ),
              ),
            )
          else
            Center(
              child: Icon(
                Icons.videocam_off_rounded,
                size: 28.sp,
                color: Colors.white.withAlpha(150),
              ),
            ),
          // زرار قلب الكاميرا — شكلى لحد ما بث الفيديو الفعلى يتربط.
          PositionedDirectional(
            bottom: 6.h,
            end: 6.w,
            child: Container(
              width: 26.w,
              height: 26.w,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.flip_camera_ios_rounded,
                size: 14.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
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
          icon: isCameraOn ? Icons.videocam_rounded : Icons.videocam_off_rounded,
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
          icon: isSpeakerOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
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
                    description: "مراجعة الأسئلة التي أضفتها ومتابعة ما تم مناقشه",
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
