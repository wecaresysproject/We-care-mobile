

import 'package:json_annotation/json_annotation.dart';

part 'biometric_filters_model.g.dart';
@JsonSerializable()
class BiometricFiltersModel {

  final List<int> years;
  final List<int> days;
  final List<int> months;

  const BiometricFiltersModel({
    required this.years,
    required this.days,
    required this.months,
  });

  factory BiometricFiltersModel.fromJson(Map<String, dynamic> json) =>
      _$BiometricFiltersModelFromJson(json);

  Map<String, dynamic> toJson() => _$BiometricFiltersModelToJson(this);

}