import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';

part 'nearest_appointment_model.g.dart';

/// أقرب موعد متاح للطبيب زى ما بيرجع من الـ API —
/// `date` بصيغة `YYYY-MM-DD` و`time` بصيغة `HH:mm` (24 ساعة).
@JsonSerializable()
class NearestAppointmentModel {
  final String date;
  final String time;

  const NearestAppointmentModel({required this.date, required this.time});

  factory NearestAppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$NearestAppointmentModelFromJson(json);
  Map<String, dynamic> toJson() => _$NearestAppointmentModelToJson(this);

  /// التاريخ والوقت مدمجين — `null` لو الصيغة الجاية من الـ API مش مفهومة.
  DateTime? get dateTime => DateTime.tryParse("${date}T$time");

  /// "الخميس 27 أغسطس" — زى ما بيتعرض فى كارت الطبيب ومعلومات الحجز.
  String get dateLabel {
    final parsed = dateTime;
    if (parsed == null) return date;
    return "${arabicWeekdayName(parsed.weekday)} ${parsed.day} "
        "${arabicMonthName(parsed.month)}";
  }

  /// "04:00 مساءً".
  String get timeLabel {
    final parsed = dateTime;
    if (parsed == null) return time;
    return arabicTimeLabel(parsed);
  }
}
