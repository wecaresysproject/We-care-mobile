/// Where a today's-appointment sits relative to its booked time —
/// "حان الموعد" (due now), "متبقي N دقيقة" (remaining) or "متأخر N دقيقة" (late).
enum AppointmentTimeStatus {
  due,
  remaining,
  late_,
}
