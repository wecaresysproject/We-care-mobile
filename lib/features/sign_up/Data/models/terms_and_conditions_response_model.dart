import 'package:json_annotation/json_annotation.dart';

part 'terms_and_conditions_response_model.g.dart';

@JsonSerializable()
class TermsAndConditionsResponseModel {
  final String createdAt;
  final String description;

  TermsAndConditionsResponseModel({
    required this.createdAt,
    required this.description,
  });

  factory TermsAndConditionsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TermsAndConditionsResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TermsAndConditionsResponseModelToJson(this);
}
