import 'package:json_annotation/json_annotation.dart';

part 'medical_specialty_request_body_model.g.dart';

@JsonSerializable()
class MedicalSpecialtyRequestBodyModel {
  final String mainSpecialty;
  final String subSpecialty;
  final String clinicalInterests;

  MedicalSpecialtyRequestBodyModel({
    required this.mainSpecialty,
    required this.subSpecialty,
    required this.clinicalInterests,
  });

  Map<String, dynamic> toJson() =>
      _$MedicalSpecialtyRequestBodyModelToJson(this);
}
