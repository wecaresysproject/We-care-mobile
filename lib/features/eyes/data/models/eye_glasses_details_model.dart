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
  final String myopiaDegree;
  final String hyperopiaDegree;
  final String astigmatismDegree;
  final String astigmatismAxis;
  final String addition;
  final String nearAddition;
  final String refractiveIndex;
  final String lensDiameter;
  final String lensCentering;
  final String lensEdgeType;
  final String lensSurfaceType;
  final String lensThickness;
  final String lensType;

  EyePrescriptionModel({
    required this.lensCentering,
    required this.lensEdgeType,
    required this.myopiaDegree,
    required this.hyperopiaDegree,
    required this.astigmatismDegree,
    required this.astigmatismAxis,
    required this.addition,
    required this.nearAddition,
    required this.refractiveIndex,
    required this.lensDiameter,
    required this.lensSurfaceType,
    required this.lensThickness,
    required this.lensType,
  });

  factory EyePrescriptionModel.fromJson(Map<String, dynamic> json) =>
      _$EyePrescriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$EyePrescriptionModelToJson(this);
}
