/// نوع الحجز — بيحدد ألوان الكارت ونصوصه وهل ليه تكلفة وأزرار إلغاء/تعديل ولا لأ.
enum BookingType {
  /// كشف أون لاين مدفوع — أزرق، وليه أزرار "إلغاء الموعد" و"تعديل الموعد".
  onlineExamination,

  /// استشارة متابعة مجانية مرتبطة بكشف سابق — خضرا، ومن غير إلغاء أو تعديل.
  freeFollowUpConsultation;

  bool get isExamination => this == BookingType.onlineExamination;

  /// اسم النوع فى بادچ الكارت وهو مستنى — "كشف أون لاين" / "استشارة متابعة مجانية".
  String get badgeLabel =>
      isExamination ? "كشف أون لاين" : "استشارة متابعة مجانية";

  /// نص البادچ لما الموعد يحين — "حان وقت الكشف" / "حان وقت الاستشارة".
  String get timeNowBadgeLabel =>
      isExamination ? "حان وقت الكشف" : "حان وقت الاستشارة";

  /// عنوان شيب العد التنازلى — "متبقى على الكشف" / "متبقى على الاستشارة".
  String get countdownLabel =>
      isExamination ? "متبقي على الكشف" : "متبقي على الاستشارة";

  /// كلمة النوع لوحدها — بتتستخدم فى الرسايل زى "لم يحن وقت الكشف بعد".
  String get shortName => isExamination ? "الكشف" : "الاستشارة";
}

/// ملخص بيانات الطبيب المعروضة فى كارت الحجز —
/// نسخة مختصرة من `DoctorModel` بنفس الشكل اللى هيرجع من endpoint الحجوزات.
class BookingDoctorInfo {
  const BookingDoctorInfo({
    required this.name,
    required this.specialization,
    required this.academicTitle,
    required this.hospital,
    required this.location,
    required this.imageUrl,
    required this.isOnline,
  });

  final String name;
  final String specialization;
  final String academicTitle;
  final String hospital;
  final String location;
  final String imageUrl;

  /// بتتحكم فى النقطة الخضرا على صورة الطبيب.
  final bool isOnline;
}

/// حجز واحد فى شاشة "حجوزاتى" — كشف أو استشارة متابعة.
class BookingModel {
  const BookingModel({
    required this.type,
    required this.doctor,
    required this.appointmentDateTime,
    this.examinationFee,
    this.linkedExaminationDate,
  })  : assert(
          type == BookingType.onlineExamination || examinationFee == null,
          "تكلفة الكشف للكشف الأون لاين بس",
        ),
        assert(
          type == BookingType.freeFollowUpConsultation ||
              linkedExaminationDate == null,
          "تاريخ الكشف المرتبط للاستشارات بس",
        );

  final BookingType type;
  final BookingDoctorInfo doctor;
  final DateTime appointmentDateTime;

  /// تكلفة الكشف بالجنيه — للكشف الأون لاين بس.
  final int? examinationFee;

  /// تاريخ الكشف اللى الاستشارة المجانية مرتبطة بيه — للاستشارات بس.
  final DateTime? linkedExaminationDate;

  /// مدة الموعد — الكارت بيفضل فى حالة "حان وقت الموعد" طولها،
  /// وبعدها بينتقل لـ"السجل السابق". نفس مدة الـ slots فى شاشة الحجز.
  static const Duration slotDuration = Duration(minutes: 30);

  /// الموعد لسه جاى — بيتعرض فى قسم "يتبقى على الموعد".
  bool isUpcoming(DateTime now) => appointmentDateTime.isAfter(now);

  /// الموعد بدأ ولسه فى وقته — بيتعرض فى قسم "حان وقت الموعد".
  bool isTimeNow(DateTime now) =>
      !appointmentDateTime.isAfter(now) &&
      now.isBefore(appointmentDateTime.add(slotDuration));

  /// الموعد خلص — مكانه تاب "السجل السابق".
  bool isPast(DateTime now) =>
      !now.isBefore(appointmentDateTime.add(slotDuration));

  Duration remaining(DateTime now) => appointmentDateTime.difference(now);

  /// "الأحد 16 أغسطس 2026".
  String get dateLabel => arabicDateLabel(appointmentDateTime);

  /// "06:00 مساءً".
  String get timeLabel => arabicTimeLabel(appointmentDateTime);

  /// "مرتبطة بكشف يوم 16 أغسطس 2026".
  String get linkedExaminationLabel {
    final linkedDate = linkedExaminationDate;
    if (linkedDate == null) return "";
    return "مرتبطة بكشف يوم ${arabicShortDateLabel(linkedDate)}";
  }
}

const List<String> _arabicWeekdays = [
  "الإثنين",
  "الثلاثاء",
  "الأربعاء",
  "الخميس",
  "الجمعة",
  "السبت",
  "الأحد",
];

const List<String> _arabicMonths = [
  "يناير",
  "فبراير",
  "مارس",
  "أبريل",
  "مايو",
  "يونيو",
  "يوليو",
  "أغسطس",
  "سبتمبر",
  "أكتوبر",
  "نوفمبر",
  "ديسمبر",
];

String arabicMonthName(int month) => _arabicMonths[month - 1];

/// اسم اليوم بالعربى — [weekday] زى `DateTime.weekday` (الإثنين = 1).
String arabicWeekdayName(int weekday) => _arabicWeekdays[weekday - 1];

/// "16 أغسطس 2026" — من غير اسم اليوم.
String arabicShortDateLabel(DateTime date) =>
    "${date.day} ${arabicMonthName(date.month)} ${date.year}";

/// "الأحد 16 أغسطس 2026".
String arabicDateLabel(DateTime date) =>
    "${_arabicWeekdays[date.weekday - 1]} ${date.day} "
    "${arabicMonthName(date.month)} ${date.year}";

/// "06:00 مساءً" — صيغة 12 ساعة بصفر بادئ زى التصميم.
String arabicTimeLabel(DateTime time) {
  final hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final period = time.hour < 12 ? "صباحاً" : "مساءً";
  return "${hour12.toString().padLeft(2, '0')}:"
      "${time.minute.toString().padLeft(2, '0')} $period";
}

/// "12 ساعة و 25 دقيقة" — مدة متبقية بصيغة عربية سليمة الجمع
/// (ساعة/ساعتين/ساعات) وبتقريب الثوانى لفوق عشان أول عرض يطابق المدة بالظبط.
String arabicCountdownLabel(Duration remaining) {
  if (remaining.isNegative) return "";

  final totalMinutes = (remaining.inSeconds / 60).ceil();
  final days = totalMinutes ~/ (24 * 60);
  final hours = (totalMinutes % (24 * 60)) ~/ 60;
  final minutes = totalMinutes % 60;

  final parts = [
    if (days > 0) _pluralizedCount(days, "يوم", "يومين", "أيام"),
    if (hours > 0) _pluralizedCount(hours, "ساعة", "ساعتين", "ساعات"),
    if (minutes > 0) _pluralizedCount(minutes, "دقيقة", "دقيقتين", "دقائق"),
  ];
  if (parts.isEmpty) return "أقل من دقيقة";

  return parts.join(" و ");
}

/// قواعد العدد العربى: 1 مفرد من غير رقم، 2 مثنى، من 3 لـ 10 جمع،
/// ومن 11 وطالع مفرد بالرقم — "ساعة"، "ساعتين"، "3 ساعات"، "12 ساعة".
String _pluralizedCount(
    int count, String singular, String dual, String plural) {
  if (count == 1) return singular;
  if (count == 2) return dual;
  if (count <= 10) return "$count $plural";
  return "$count $singular";
}
