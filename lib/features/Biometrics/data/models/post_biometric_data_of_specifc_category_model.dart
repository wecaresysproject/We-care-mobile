import 'package:json_annotation/json_annotation.dart';

part 'post_biometric_data_of_specifc_category_model.g.dart';

@JsonSerializable()
class PostBiometricCategoryModel {
  @JsonKey(name: 'CategoryName')
  final String categoryName;

  @JsonKey(name: 'MaxValue')
  final String? maxValue;

  @JsonKey(name: 'MinValue')
  final String minValue;

  PostBiometricCategoryModel({
    required this.categoryName,
    this.maxValue,
    required this.minValue,
  });

  factory PostBiometricCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$PostBiometricCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostBiometricCategoryModelToJson(this);
}
