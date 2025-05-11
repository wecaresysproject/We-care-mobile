import 'package:json_annotation/json_annotation.dart';

part 'body_symptom.g.dart';

@JsonSerializable()
class BodySymptom {
  final String mainArea;
  final String bodyPart;
  @JsonKey(name: 'search')
  final String description;

  BodySymptom({
    required this.mainArea,
    required this.bodyPart,
    required this.description,
  });

  factory BodySymptom.fromJson(Map<String, dynamic> json) =>
      _$BodySymptomFromJson(json);

  Map<String, dynamic> toJson() => _$BodySymptomToJson(this);
}
