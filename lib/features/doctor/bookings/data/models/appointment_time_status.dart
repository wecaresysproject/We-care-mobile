import 'package:json_annotation/json_annotation.dart';

/// Where a today's-appointment sits relative to its booked time —
/// "حان الموعد" (due now), "متبقي N دقيقة" (remaining) or "متأخر N دقيقة" (late).
enum AppointmentTimeStatus {
  @JsonValue('due')
  due,
  @JsonValue('remaining')
  remaining,
  @JsonValue('late')
  late_,
}
