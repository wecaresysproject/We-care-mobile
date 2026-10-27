import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

// أجزاء شاشة المكالمة المشتركة بين شاشة المريض وشاشة المشارك.

/// محتوى رسالة الحالة فوق الفيديو — نص اختيارى، مؤشر تحميل، وزرار اختيارى.
class CallNotice {
  const CallNotice({
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
class CallPlaceholder extends StatelessWidget {
  const CallPlaceholder(
      {super.key, required this.imageUrl, required this.notice});

  final String imageUrl;
  final CallNotice notice;

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
class CallTopBar extends StatelessWidget {
  const CallTopBar(
      {super.key, required this.statusLabel, required this.elapsedLabel});

  final String statusLabel;
  final String elapsedLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // أول عنصر بيترسم يمين فى الـ RTL — زرار الخيارات على الشمال زى التصميم.
        const RoundGlassButton(icon: Icons.more_horiz_rounded),
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
        const RoundGlassButton(icon: Icons.shield_outlined),
      ],
    );
  }
}

/// زرار دائرى زجاجى غامق — شكلى لحد ما خيارات المكالمة تتحدد.
class RoundGlassButton extends StatelessWidget {
  const RoundGlassButton({super.key, required this.icon});

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
class EncryptionChip extends StatelessWidget {
  const EncryptionChip({super.key});

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

/// صف أزرار التحكم — ميكروفون وكاميرا وإنهاء، ومكبر صوت اختيارى.
class CallControlsRow extends StatelessWidget {
  const CallControlsRow({
    super.key,
    required this.endCallLabel,
    required this.isMicOn,
    required this.isCameraOn,
    required this.onMicPressed,
    required this.onCameraPressed,
    required this.onEndCallPressed,
    this.isSpeakerOn = true,
    this.onSpeakerPressed,
  });

  /// تسمية زرار الإنهاء — "إنهاء الكشف" للمريض، "خروج" للمشارك.
  final String endCallLabel;
  final bool isMicOn;
  final bool isCameraOn;
  final bool isSpeakerOn;
  final VoidCallback onMicPressed;
  final VoidCallback onCameraPressed;

  /// `null` بيخفى زرار مكبر الصوت.
  final VoidCallback? onSpeakerPressed;
  final VoidCallback onEndCallPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CallControlButton(
          icon: isMicOn ? Icons.mic_rounded : Icons.mic_off_rounded,
          label: "الميكروفون",
          isActive: isMicOn,
          onPressed: onMicPressed,
        ),
        CallControlButton(
          icon:
              isCameraOn ? Icons.videocam_rounded : Icons.videocam_off_rounded,
          label: "الكاميرا",
          isActive: isCameraOn,
          onPressed: onCameraPressed,
        ),
        CallControlButton(
          icon: Icons.call_end_rounded,
          label: endCallLabel,
          backgroundColor: OnlineDoctorTheme.offlineRed,
          contentColor: Colors.white,
          size: 64,
          onPressed: onEndCallPressed,
        ),
        if (onSpeakerPressed case final onSpeakerPressed?)
          CallControlButton(
            icon: isSpeakerOn
                ? Icons.volume_up_rounded
                : Icons.volume_off_rounded,
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
class CallControlButton extends StatelessWidget {
  const CallControlButton({
    super.key,
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
