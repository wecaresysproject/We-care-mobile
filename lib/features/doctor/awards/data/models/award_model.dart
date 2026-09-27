import 'package:json_annotation/json_annotation.dart';

part 'award_model.g.dart';

@JsonSerializable()
class AwardModel {
  final String awardName;
  final String countryName;
  final String grantingBody;
  final String year;

  AwardModel({
    required this.awardName,
    required this.countryName,
    required this.grantingBody,
    required this.year,
  });

  Map<String, dynamic> toJson() => _$AwardModelToJson(this);
}
