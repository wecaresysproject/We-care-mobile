import 'package:flutter/material.dart';
import 'package:we_care/features/doctor/booking_settings/data/models/weekday.dart';
import 'package:we_care/generated/l10n.dart';

/// Localized display label for a [Weekday], shared by every widget that
/// lists weekdays on the Booking Settings screen.
String weekdayLabel(BuildContext context, Weekday day) {
  final localization = S.of(context);
  return switch (day) {
    Weekday.saturday => localization.daySaturday,
    Weekday.sunday => localization.daySunday,
    Weekday.monday => localization.dayMonday,
    Weekday.tuesday => localization.dayTuesday,
    Weekday.wednesday => localization.dayWednesday,
    Weekday.thursday => localization.dayThursday,
    Weekday.friday => localization.dayFriday,
  };
}
