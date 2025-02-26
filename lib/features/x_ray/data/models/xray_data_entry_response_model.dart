import 'package:freezed_annotation/freezed_annotation.dart';

part 'xray_data_entry_response_model.g.dart';

@JsonSerializable()
class XrayDataEntryResponseBodyModel {
  @JsonKey(name: "radiologyDate")
  final String radiologyDate;
  @JsonKey(name: "bodyPart")
  final String bodyPartName;
  @JsonKey(name: "radioType")
  final String radiologyType;
  final String photo;
  @JsonKey(name: "periodicUsage")
  final String? radiologyTypePurposes;
  final String? report;
  final String? cause;
  final String? hospital;
  final String? radiologyDoctor;
  final String? curedDoctor;
  final String? country;
  final String? radiologyNote;
  final String userType;

  XrayDataEntryResponseBodyModel({
    required this.radiologyDate,
    required this.bodyPartName,
    required this.radiologyType,
    required this.radiologyTypePurposes,
    required this.photo,
    required this.report,
    required this.cause,
    required this.hospital,
    required this.radiologyDoctor,
    required this.curedDoctor,
    required this.country,
    required this.radiologyNote,
    required this.userType,
  });

  factory XrayDataEntryResponseBodyModel.fromJson(Map<String, dynamic> json) =>
      _$XrayDataEntryResponseBodyModelFromJson(json);
}
