import 'package:json_annotation/json_annotation.dart';

part 'body_symptom.g.dart';

@JsonSerializable()
class BodySymptom {
  final String keyword;
  final String mainArea;
  final String bodyPart;
  final String description;

  BodySymptom({
    required this.keyword,
    required this.mainArea,
    required this.bodyPart,
    required this.description,
  });

  factory BodySymptom.fromJson(Map<String, dynamic> json) =>
      _$BodySymptomFromJson(json);

  Map<String, dynamic> toJson() => _$BodySymptomToJson(this);
}
