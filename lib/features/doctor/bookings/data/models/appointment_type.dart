import 'package:json_annotation/json_annotation.dart';

/// "كشف" (examination) vs "استشارة" (consultation) appointment type badge.
enum AppointmentType {
  @JsonValue('examination')
  examination,
  @JsonValue('consultation')
  consultation,
}
