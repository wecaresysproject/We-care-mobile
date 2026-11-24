import 'package:json_annotation/json_annotation.dart';

part 'doctor_monthly_examinations_model.g.dart';

/// Current calendar month's examination target vs. achieved —
/// `GET /DoctorHome/monthly-examinations`.
@JsonSerializable(createToJson: false)
class DoctorMonthlyExaminationsModel {
  DoctorMonthlyExaminationsModel({
    required this.targetCount,
    required this.achievedCount,
  });

  @JsonKey(defaultValue: 0)
  final int targetCount;
  @JsonKey(defaultValue: 0)
  final int achievedCount;

  factory DoctorMonthlyExaminationsModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorMonthlyExaminationsModelFromJson(json);
}
