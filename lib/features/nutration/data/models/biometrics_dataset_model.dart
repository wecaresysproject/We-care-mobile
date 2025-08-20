import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

part 'biometrics_dataset_model.g.dart';

@JsonSerializable()
 class BiometricsDatasetModel {
  @JsonKey(name: 'metric')
  final String type; // e.g. 'heart_rate', 'blood_pressure'
  final List<BiometricData> data;

  BiometricsDatasetModel({required this.type, required this.data});
  factory BiometricsDatasetModel.fromJson(Map<String, dynamic> json) =>
      _$BiometricsDatasetModelFromJson(json);
}

@JsonSerializable()
class BiometricData {
  @JsonKey(name: 'time')
  final String date;
  @JsonKey(name: 'minValue')
  final String value;
  @JsonKey(name: 'maxValue')
  final String? secondaryValue; // For blood pressure (diastolic)

  BiometricData({
    required this.date,
    required this.value,
    this.secondaryValue,
  });
  factory BiometricData.fromJson(Map<String, dynamic> json) =>
      _$BiometricDataFromJson(json);
}


// This local class is used to map biometric names to their types, icons, and colors.
class BiometricType {
  final String id;
  final String name;
  final String icon;
  final Color color;
  final bool hasSecondaryValue;

  BiometricType({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.hasSecondaryValue = false,
  });
}
