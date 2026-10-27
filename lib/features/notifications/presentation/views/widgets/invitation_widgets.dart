import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';

// أجزاء مشتركة بين كارت دعوة الاستشارة وصفحة تفاصيلها.

/// لون الأسطح الفاتحة جوه الكارت — درجة خفيفة من اللون الأساسى.
final Color invitationSurface =
    AppColorsManager.mainDarkBlue.withValues(alpha: 0.05);

/// صورة شخص فى دايرة — ولو مفيش صورة أيقونة شخص على خلفية [background].
class InvitationAvatar extends StatelessWidget {
  const InvitationAvatar({
    super.key,
    required this.imageUrl,
    required this.size,
    required this.background,
    required this.iconColor,
  });

  final String imageUrl;
  final double size;
  final Color background;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: background,
      alignment: Alignment.bottomCenter,
      child: Icon(Icons.person_rounded, size: size * 0.8, color: iconColor),
    );
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: imageUrl.isEmpty
            ? fallback
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => fallback,
                errorWidget: (_, __, ___) => fallback,
              ),
      ),
    );
  }
}

/// صورة المريض صاحب الدعوة — رمادى زى التصميم.
class InviterAvatar extends StatelessWidget {
  const InviterAvatar({super.key, required this.imageUrl, required this.size});

  final String imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InvitationAvatar(
      imageUrl: imageUrl,
      size: size,
      background: const Color(0xFFE4E7EB),
      iconColor: const Color(0xFF9AA3AD),
    );
  }
}

/// صورة الطبيب — بدرجة من اللون الأساسى.
class InvitationDoctorAvatar extends StatelessWidget {
  const InvitationDoctorAvatar({
    super.key,
    required this.imageUrl,
    required this.size,
  });

  final String imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InvitationAvatar(
      imageUrl: imageUrl,
      size: size,
      background: AppColorsManager.mainDarkBlue.withValues(alpha: 0.12),
      iconColor: AppColorsManager.mainDarkBlue.withValues(alpha: 0.75),
    );
  }
}

/// "الأحد 25 أكتوبر".
String invitationDayLabel(DateTime date) =>
    "${arabicWeekdayName(date.weekday)} ${date.day} ${arabicMonthName(date.month)}";

/// "25 أكتوبر 2026".
String invitationDateLabel(DateTime date) => arabicShortDateLabel(date);

/// "8:30 مساءً".
String invitationTimeLabel(DateTime time) {
  final hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final period = time.hour < 12 ? "صباحاً" : "مساءً";
  return "$hour12:${time.minute.toString().padLeft(2, '0')} $period";
}

/// "بعد 4 أيام" — المدة لحد الموعد بأكبر وحدة.
String invitationCountdownLabel(DateTime startsAt, DateTime now) {
  final remaining = startsAt.difference(now);
  if (remaining.isNegative) return "حان الموعد";
  if (remaining.inDays > 0) {
    return "بعد ${_count(remaining.inDays, "يوم", "يومين", "أيام", "يومًا")}";
  }
  if (remaining.inHours > 0) {
    return "بعد ${_count(remaining.inHours, "ساعة", "ساعتين", "ساعات", "ساعة")}";
  }
  final minutes = remaining.inMinutes < 1 ? 1 : remaining.inMinutes;
  return "بعد ${_count(minutes, "دقيقة", "دقيقتين", "دقائق", "دقيقة")}";
}

/// العدد مع التمييز الصح: يوم، يومين، 3 أيام، 11 يومًا.
String _count(int n, String one, String two, String few, String many) {
  if (n == 1) return one;
  if (n == 2) return two;
  if (n <= 10) return "$n $few";
  return "$n $many";
}

/// "استشارة فيديو" / "كشف أون لاين" — نوع الموعد فى عنوان الدعوة.
String invitationMeetingName(BookingType type) =>
    type.isExamination ? "كشف أون لاين" : "استشارة فيديو";
