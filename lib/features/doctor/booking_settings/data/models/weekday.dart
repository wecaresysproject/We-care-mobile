import 'package:json_annotation/json_annotation.dart';

/// Days of the week in the order the Booking Settings screen displays them
/// (Saturday first, matching the Arabic week start).
enum Weekday {
  @JsonValue('saturday')
  saturday,
  @JsonValue('sunday')
  sunday,
  @JsonValue('monday')
  monday,
  @JsonValue('tuesday')
  tuesday,
  @JsonValue('wednesday')
  wednesday,
  @JsonValue('thursday')
  thursday,
  @JsonValue('friday')
  friday,
}
