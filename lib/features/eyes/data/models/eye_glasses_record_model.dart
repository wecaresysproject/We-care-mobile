import 'package:json_annotation/json_annotation.dart';

part 'eye_glasses_record_model.g.dart';

@JsonSerializable()
class EyeGlassesRecordModel {
  final String id;
  final String date;

  @JsonKey(name: 'doctorName/hospitalName')
  final String doctorOrHospitalName;

  final String rightEyeSphericalPower;

  final String leftEyeSphericalPower;
  final String storeName;

  EyeGlassesRecordModel({
    required this.id,
    required this.date,
    required this.doctorOrHospitalName,
    required this.rightEyeSphericalPower,
    required this.leftEyeSphericalPower,
    required this.storeName,
  });

  factory EyeGlassesRecordModel.fromJson(Map<String, dynamic> json) =>
      _$EyeGlassesRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$EyeGlassesRecordModelToJson(this);
}
