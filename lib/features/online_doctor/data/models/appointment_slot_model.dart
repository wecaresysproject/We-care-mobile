import 'package:we_care/features/online_doctor/data/models/booking_model.dart';

/// توقيت واحد متاح للحجز جوه يوم معيّن — بيتعرض ككارت فى صف التوقيتات.
class AppointmentTimeSlot {
  const AppointmentTimeSlot({
    required this.startsAt,
    required this.endsAt,
  });

  final DateTime startsAt;
  final DateTime endsAt;

  /// [date] هو يوم الميعاد، والـ API بيرجّع `startTime` / `endTime` بصيغة
  /// `HH:mm` بتوقيت مصر.
  factory AppointmentTimeSlot.fromJson(
    Map<String, dynamic> json,
    DateTime date,
  ) =>
      AppointmentTimeSlot(
        startsAt: _timeOnDate(date, json['startTime'] as String),
        endsAt: _timeOnDate(date, json['endTime'] as String),
      );

  /// بداية الميعاد زى ما الـ API مستنيها فى الحجز — "13:30".
  String get apiStartTime => "${_twoDigits(startsAt.hour)}:"
      "${_twoDigits(startsAt.minute)}";

  /// بداية الميعاد — "12:30م".
  String get fromTime => _compactTimeLabel(startsAt);

  /// نهاية الميعاد — "1م".
  String get toTime => _compactTimeLabel(endsAt);
}

/// يوم متاح للحجز مع توقيتاته — اليوم بيتعرض فى صف الأيام فوق،
/// ولما المستخدم يختاره توقيتاته بتظهر تحته.
class AppointmentDayModel {
  const AppointmentDayModel({
    required this.date,
    required this.slots,
  });

  /// تاريخ اليوم — الوقت فيه مش مستخدم.
  final DateTime date;

  /// التوقيتات المتاحة فى اليوم دا مرتبة من الأبكر للأبعد.
  final List<AppointmentTimeSlot> slots;

  factory AppointmentDayModel.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['date'] as String);
    return AppointmentDayModel(
      date: date,
      slots: (json['slots'] as List? ?? const [])
          .map((e) =>
              AppointmentTimeSlot.fromJson(e as Map<String, dynamic>, date))
          .toList(),
    );
  }

  /// تاريخ اليوم زى ما الـ API مستنيه فى الحجز — "2026-10-06".
  String get apiDate =>
      "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";

  /// كارت "اليوم" ليه شكل مختلف شوية فى التصميم — سطر واحد بخط أكبر.
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// اسم اليوم — "اليوم" أو "الثلاثاء".
  String get dayLabel => isToday ? "اليوم" : arabicWeekdayName(date.weekday);

  /// تاريخ اليوم بالأرقام العربية — "١٠ / ٧".
  /// بيبقى `null` فى كارت "اليوم" لأنه بيتعرض بسطر واحد أكبر.
  String? get dateLabel => isToday
      ? null
      : "${_arabicIndicDigits(date.day)} / ${_arabicIndicDigits(date.month)}";
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

/// "13:30" على يوم [date].
DateTime _timeOnDate(DateTime date, String time) {
  final parts = time.split(":");
  return DateTime(
    date.year,
    date.month,
    date.day,
    int.parse(parts[0]),
    int.parse(parts[1]),
  );
}

/// "12:30م" / "1م" — صيغة 12 ساعة مختصرة، والدقايق بتتشال لو صفر.
String _compactTimeLabel(DateTime time) {
  final hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final minutes =
      time.minute == 0 ? "" : ":${time.minute.toString().padLeft(2, '0')}";
  return "$hour12$minutes${time.hour < 12 ? "ص" : "م"}";
}

/// 10 → "١٠".
String _arabicIndicDigits(int number) {
  const digits = ["٠", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩"];
  return number.toString().split("").map((d) => digits[int.parse(d)]).join();
}
