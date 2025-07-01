import 'package:freezed_annotation/freezed_annotation.dart';

part 'eye_part_syptoms_and_procedures_response_model.g.dart';

@JsonSerializable()
class EyePartSyptomsAndProceduresResponseModel {
  @JsonKey(name: 'asymptoms')
  final List<String> symptoms;
  @JsonKey(name: 'medicalTests')
  final List<String> procedures;

  EyePartSyptomsAndProceduresResponseModel({
    required this.symptoms,
    required this.procedures,
  });

  factory EyePartSyptomsAndProceduresResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$EyePartSyptomsAndProceduresResponseModelFromJson(json);
}
