import 'package:json_annotation/json_annotation.dart';

part 'eye_glasses_lens_data_request_body_model.g.dart';

@JsonSerializable()
class EyeGlassesLensDataRequestBodyModel {
  final LensData? leftLens;
  final LensData? rightLens;
  @JsonKey(name: 'essentialGlassData')
  final EssentialGlassesData essentialGlassData;

  EyeGlassesLensDataRequestBodyModel({
    this.leftLens,
    this.rightLens,
    required this.essentialGlassData,
  });

  factory EyeGlassesLensDataRequestBodyModel.fromJson(
          Map<String, dynamic> json) =>
      _$EyeGlassesLensDataRequestBodyModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EyeGlassesLensDataRequestBodyModelToJson(this);
}

@JsonSerializable()
class LensData {
  /// Degree of myopia (قصر النظر), e.g., -2.50
  final String myopiaDegree;

  /// Degree of hyperopia (طول النظر), e.g., +2.00
  final String hyperopiaDegree;

  /// Astigmatism value (الاستجماتيزم), cylinder
  final String? astigmatismDegree;

  /// Axis of astigmatism (محور الاستجماتيزم)
  final String? astigmatismAxis;

  /// Near addition (الاضافة البؤرية)
  final String? nearAddition;

  /// Pupillary distance (تباعد الحدقتين)
  final String? pupillaryDistance;

  /// Refractive index (معامل الانكسار)
  final String? refractiveIndex;

  /// Diameter of the lens (قطر العدسة)
  final String? lensDiameter;

  /// Lens centering (المركز)
  final String? lensCentering;

  /// Type of the lens edge (الحواف), e.g., Thin or Thick
  final String? lensEdgeType;

  /// Type of the lens surface (سطح العدسة), e.g., Aspheric
  final String? lensSurfaceType;

  /// Thickness of the lens (سمك العدسة)
  final String? lensThickness;

  /// Type of the lens (نوع العدسة), e.g., Progressive
  final String? lensType;

  LensData({
    required this.myopiaDegree,
    required this.hyperopiaDegree,
    this.astigmatismDegree,
    this.astigmatismAxis,
    this.nearAddition,
    this.pupillaryDistance,
    this.refractiveIndex,
    this.lensDiameter,
    this.lensCentering,
    this.lensEdgeType,
    this.lensSurfaceType,
    this.lensThickness,
    this.lensType,
  });

  factory LensData.fromJson(Map<String, dynamic> json) =>
      _$LensDataFromJson(json);

  Map<String, dynamic> toJson() => _$LensDataToJson(this);
}

@JsonSerializable()
class EssentialGlassesData {
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

  EssentialGlassesData({
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

  factory EssentialGlassesData.fromJson(Map<String, dynamic> json) =>
      _$EssentialGlassesDataFromJson(json);

  Map<String, dynamic> toJson() => _$EssentialGlassesDataToJson(this);
}
