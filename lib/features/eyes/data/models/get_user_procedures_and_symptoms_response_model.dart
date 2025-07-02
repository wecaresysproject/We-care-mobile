import 'package:json_annotation/json_annotation.dart';

part 'get_user_procedures_and_symptoms_response_model.g.dart';

@JsonSerializable()
class UserProceduresAndSymptoms {
  final String message;
  final List<ProcedureAndSymptomItem> data;

  UserProceduresAndSymptoms({
    required this.message,
    required this.data,
  });

  factory UserProceduresAndSymptoms.fromJson(Map<String, dynamic> json) =>
      _$UserProceduresAndSymptomsFromJson(json);

  Map<String, dynamic> toJson() => _$UserProceduresAndSymptomsToJson(this);
}

@JsonSerializable()
class ProcedureAndSymptomItem {
  final String id;
  final String date;
  final List<String> procedures;
  final List<String> symptoms;

  ProcedureAndSymptomItem({
    required this.id,
    required this.date,
    required this.procedures,
    required this.symptoms,
  });

  factory ProcedureAndSymptomItem.fromJson(Map<String, dynamic> json) =>
      _$ProcedureAndSymptomItemFromJson(json);

  Map<String, dynamic> toJson() => _$ProcedureAndSymptomItemToJson(this);
}
