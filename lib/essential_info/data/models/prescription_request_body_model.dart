import 'package:json_annotation/json_annotation.dart';

part 'prescription_request_body_model.g.dart';

@JsonSerializable()
class PrescriptionRequestBodyModel {
  @JsonKey(name: 'UserType')
  final String userType;
  @JsonKey(name: 'Language')
  final String language;
  @JsonKey(name: 'PreDescriptionDate')
  final String prescriptionDate;
  @JsonKey(name: 'DoctorName')
  final String doctorName;
  @JsonKey(name: 'DoctorSpecialty')
  final String doctorSpecialty;
  final String cause;
  final String disease;
  @JsonKey(name: 'PreDescriptionPhoto')
  final String preDescriptionPhoto;
  final String country;
  final String governate;
  @JsonKey(name: 'PreDescriptionNotes')
  final String preDescriptionNotes;

  PrescriptionRequestBodyModel({
    required this.userType,
    required this.language,
    required this.prescriptionDate,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.cause,
    required this.disease,
    required this.preDescriptionPhoto,
    required this.country,
    required this.governate,
    required this.preDescriptionNotes,
  });

  Map<String, dynamic> toJson() => _$PrescriptionRequestBodyModelToJson(this);
}
