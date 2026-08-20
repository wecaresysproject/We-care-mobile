/// توقيت واحد متاح للحجز جوه يوم معيّن — بيتعرض ككارت فى صف التوقيتات.
class AppointmentTimeSlot {
  const AppointmentTimeSlot({
    required this.fromTime,
    required this.toTime,
  });

  /// بداية الميعاد — "12:30م".
  final String fromTime;

  /// نهاية الميعاد — "1م".
  final String toTime;
}

/// يوم متاح للحجز مع توقيتاته — اليوم بيتعرض فى صف الأيام فوق،
/// ولما المستخدم يختاره توقيتاته بتظهر تحته.
class AppointmentDayModel {
  const AppointmentDayModel({
    required this.dayLabel,
    required this.slots,
    this.dateLabel,
  });

  /// اسم اليوم — "اليوم" أو "الثلاثاء".
  final String dayLabel;

  /// تاريخ اليوم بالأرقام العربية — "١٠ / ٧".
  /// بيبقى `null` فى كارت "اليوم" لأنه بيتعرض بسطر واحد أكبر.
  final String? dateLabel;

  /// التوقيتات المتاحة فى اليوم دا مرتبة من الأبكر للأبعد.
  final List<AppointmentTimeSlot> slots;

  /// كارت "اليوم" ليه شكل مختلف شوية فى التصميم — سطر واحد بخط أكبر.
  bool get isToday => dateLabel == null;
}
