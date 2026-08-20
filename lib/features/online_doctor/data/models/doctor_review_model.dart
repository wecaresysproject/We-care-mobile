import 'package:json_annotation/json_annotation.dart';

part 'doctor_review_model.g.dart';

@JsonSerializable()
class DoctorReviewModel {
  final String patientName;
  final String comment;

  const DoctorReviewModel({
    required this.patientName,
    required this.comment,
  });

  factory DoctorReviewModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorReviewModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorReviewModelToJson(this);
}
