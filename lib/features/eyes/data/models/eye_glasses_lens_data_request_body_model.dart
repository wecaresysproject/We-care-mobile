import 'package:json_annotation/json_annotation.dart';

part 'eye_glasses_lens_data_request_body_model.g.dart';

@JsonSerializable()
class EyeGlassesLensDataRequestBodyModel {
  final LensData? leftLens;
  final LensData? rightLens;

  EyeGlassesLensDataRequestBodyModel({
    this.leftLens,
    this.rightLens,
  });

  factory EyeGlassesLensDataRequestBodyModel.fromJson(
          Map<String, dynamic> json) =>
      _$EyeGlassesLensDataRequestBodyModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EyeGlassesLensDataRequestBodyModelToJson(this);
}

@JsonSerializable()
class LensData {
  final String? sphere;
  final String? cylinder;
  final String? axis;
  final String? add;
  final String? pd;
  final String? refractiveIndex;
  final String? diameter;
  final String? center;
  final String? edges;
  final String? surface;
  final String? thickness;
  final String? type;

  LensData({
    this.sphere,
    this.cylinder,
    this.axis,
    this.add,
    this.pd,
    this.refractiveIndex,
    this.diameter,
    this.center,
    this.edges,
    this.surface,
    this.thickness,
    this.type,
  });

  factory LensData.fromJson(Map<String, dynamic> json) =>
      _$LensDataFromJson(json);

  Map<String, dynamic> toJson() => _$LensDataToJson(this);
}
