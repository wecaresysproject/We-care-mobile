import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/doctor/bookings/data/models/appointment_type.dart';

part 'doctor_comment_model.g.dart';

/// A patient's comment on the doctor's profile.
@JsonSerializable(createToJson: false)
class DoctorCommentModel {
  DoctorCommentModel({
    required this.id,
    required this.patientName,
    required this.comment,
    required this.createdAt,
  });

  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String patientName;
  @JsonKey(defaultValue: '')
  final String comment;

  /// وقت كتابة التعليق — ISO 8601 بالـ offset، بيتعرض بتوقيت الجهاز.
  @JsonKey(fromJson: _parseCreatedAt)
  final DateTime createdAt;

  factory DoctorCommentModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorCommentModelFromJson(json);
}

DateTime _parseCreatedAt(Object? value) =>
    parseBookingsInstant(value) ?? DateTime.now();
