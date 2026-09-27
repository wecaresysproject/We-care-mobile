import 'package:json_annotation/json_annotation.dart';

part 'doctor_comment_model.g.dart';

@JsonSerializable()
class DoctorCommentModel {
  DoctorCommentModel({
    required this.patientName,
    required this.comment,
  });

  final String patientName;
  final String comment;

  factory DoctorCommentModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorCommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorCommentModelToJson(this);
}
