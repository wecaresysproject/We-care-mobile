import 'package:json_annotation/json_annotation.dart';

part 'country_response_model.g.dart';

@JsonSerializable()
class CountryModel {
  final String code;
  final String name;
  @JsonKey(name: "flag")
  final String countryFlag;
  final String continent;

  CountryModel({
    required this.code,
    required this.name,
    required this.countryFlag,
    required this.continent,
  });
  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);
}
