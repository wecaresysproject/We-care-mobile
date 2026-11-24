import 'package:json_annotation/json_annotation.dart';

part 'doctor_bookings_stats_model.g.dart';

/// Today's booking counters — `GET /DoctorHome/bookings-stats`.
@JsonSerializable(createToJson: false)
class DoctorBookingsStatsModel {
  DoctorBookingsStatsModel({
    required this.waitingCount,
    required this.followUpsCount,
    required this.currentBookingsCount,
    required this.allowedBookingsCount,
  });

  @JsonKey(defaultValue: 0)
  final int waitingCount;
  @JsonKey(defaultValue: 0)
  final int followUpsCount;
  @JsonKey(defaultValue: 0)
  final int currentBookingsCount;
  @JsonKey(defaultValue: 0)
  final int allowedBookingsCount;

  factory DoctorBookingsStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorBookingsStatsModelFromJson(json);
}
