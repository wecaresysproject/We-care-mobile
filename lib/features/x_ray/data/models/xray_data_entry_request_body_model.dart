import 'package:freezed_annotation/freezed_annotation.dart';

part 'xray_data_entry_request_body_model.g.dart';

@JsonSerializable()
class XrayDataEntryRequestBodyModel {
  @JsonKey(name: "RadiologyDate")
  final String radiologyDate;
  @JsonKey(name: "BodyPart")
  final String bodyPartName;
  @JsonKey(name: "RadioType")
  final String radiologyType;
  @JsonKey(name: "PeriodicUsage")
  final String? radiologyTypePurposes;
  @JsonKey(name: "xrayImages")
  final List<String> xrayImages;
  @JsonKey(name: "reportImages")
  final List<String> reportImages;
  final String? cause;
  final String? hospital;
  @JsonKey(name: "RadiologyDoctor")
  final String? radiologyDoctor;
  @JsonKey(name: "CuredDoctor")
  final String? curedDoctor;
  final String? country;
  @JsonKey(name: "RadiologyNote")
  final String? radiologyNote;
  @JsonKey(name: "UserType")
  final String userType;
  @JsonKey(name: "Language")
  final String language;
  final String writtenReport;

  XrayDataEntryRequestBodyModel({
    required this.radiologyDate,
    required this.bodyPartName,
    required this.radiologyType,
    required this.radiologyTypePurposes,
    required this.xrayImages,
    required this.reportImages,
    required this.cause,
    required this.hospital,
    required this.radiologyDoctor,
    required this.curedDoctor,
    required this.country,
    required this.radiologyNote,
    required this.userType,
    required this.language,
    required this.writtenReport,
  });

  Map<String, dynamic> toJson() => _$XrayDataEntryRequestBodyModelToJson(this);
}
