import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_parts_response_model.g.dart';

@JsonSerializable()
class BodyPartsResponseModel {
  BodyPartsResponseModel({
    required this.id,
    required this.bodyPartName,
    required this.radiologyTypeOfBodyPart,
  });
  final String id;
  @JsonKey(name: 'bodyPart')
  final String bodyPartName;
  @JsonKey(name: 'imagingTypes')
  List<RadiologyTypeOfBodyPartModel> radiologyTypeOfBodyPart;

  factory BodyPartsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BodyPartsResponseModelFromJson(json);
}

// نوع الاشاعه بناءا عن نوع العضو
@JsonSerializable()
class RadiologyTypeOfBodyPartModel {
  RadiologyTypeOfBodyPartModel({
    required this.type,
    required this.purposes,
  });
  final String type;
  final List<String> purposes;

  factory RadiologyTypeOfBodyPartModel.fromJson(Map<String, dynamic> json) =>
      _$RadiologyTypeOfBodyPartModelFromJson(json);
}
