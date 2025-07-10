import 'package:json_annotation/json_annotation.dart';

part 'eye_glasses_record_model.g.dart';

@JsonSerializable()
class EyeGlassesRecordModel {
  final String id;
  final String date;

  final String rightEyeSphericalPower;

  final String leftEyeSphericalPower;
  final String storeName;
  final String doctorName;
  final String hospitalName;

  EyeGlassesRecordModel({
    required this.id,
    required this.date,
    required this.doctorName,
    required this.hospitalName,
    required this.rightEyeSphericalPower,
    required this.leftEyeSphericalPower,
    required this.storeName,
  });

  factory EyeGlassesRecordModel.fromJson(Map<String, dynamic> json) =>
      _$EyeGlassesRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$EyeGlassesRecordModelToJson(this);
}
