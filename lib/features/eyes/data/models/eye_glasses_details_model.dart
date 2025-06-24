import 'package:json_annotation/json_annotation.dart';

part 'eye_glasses_details_model.g.dart';

@JsonSerializable()
class EyeGlassesDetailsModel {
  final String id;
  final String date;
  final String doctorName;
  final String hospitalName;
  final String storeName;
  final bool? antiReflection;
  final bool? scratchResistance;
  final bool? blueLightProtection;
  final bool? uvProtection;
  final bool? antiFog;
  final bool? fingerprintResistance;
  final EyePrescriptionModel rightEye;
  final EyePrescriptionModel leftEye;

  EyeGlassesDetailsModel({
    required this.id,
    required this.date,
    required this.doctorName,
    required this.hospitalName,
    required this.storeName,
    required this.antiReflection,
    required this.scratchResistance,
    required this.blueLightProtection,
    required this.uvProtection,
    required this.antiFog,
    required this.fingerprintResistance,
    required this.rightEye,
    required this.leftEye,
  });

  factory EyeGlassesDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$EyeGlassesDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$EyeGlassesDetailsModelToJson(this);
}

@JsonSerializable()
class EyePrescriptionModel {
  final String nearsightedness;
  final String farsightedness;
  final String cylinder;
  final String cylinderAxis;
  final String addition;
  final String bifocalSegment;
  final String refractionCoefficient;
  final String lensDiameter;
  final String center;
  final String edges;
  final String lensSurface;
  final String lensThickness;
  final String lensType;

  EyePrescriptionModel({
    required this.center,
    required this.edges,
    required this.nearsightedness,
    required this.farsightedness,
    required this.cylinder,
    required this.cylinderAxis,
    required this.addition,
    required this.bifocalSegment,
    required this.refractionCoefficient,
    required this.lensDiameter,
    required this.lensSurface,
    required this.lensThickness,
    required this.lensType,
  });

  factory EyePrescriptionModel.fromJson(Map<String, dynamic> json) =>
      _$EyePrescriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$EyePrescriptionModelToJson(this);
}
