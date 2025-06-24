import 'package:json_annotation/json_annotation.dart';

part 'eye_glasses_essential_data_request_body_model.g.dart';

@JsonSerializable()
class EyeGlassesEssentialDataRequestBodyModel {
  final String examinationDate;
  final String? doctorName;
  final String? centerHospitalName;
  final String? glassesShop;
  final bool? antiReflection;
  final bool? blueLightProtection;
  final bool? scratchResistance;
  final bool? antiFingerprintCoating;
  final bool? antiFogCoating;
  final bool? uvProtection;

  EyeGlassesEssentialDataRequestBodyModel({
    required this.examinationDate,
    this.doctorName,
    this.centerHospitalName,
    this.glassesShop,
    this.antiReflection,
    this.blueLightProtection,
    this.scratchResistance,
    this.antiFingerprintCoating,
    this.antiFogCoating,
    this.uvProtection,
  });

  factory EyeGlassesEssentialDataRequestBodyModel.fromJson(
          Map<String, dynamic> json) =>
      _$EyeGlassesEssentialDataRequestBodyModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EyeGlassesEssentialDataRequestBodyModelToJson(this);
}
