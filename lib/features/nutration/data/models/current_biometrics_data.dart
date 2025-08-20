import 'package:json_annotation/json_annotation.dart';

part 'current_biometrics_data.g.dart';

@JsonSerializable()
class CurrentBioMetricsData {
  Rate? heartRate;
  Rate? oxygenLevel;
  Rate? bloodPressure;
  Rate? randomBloodSugar;
  Rate? fastingBloodSugar;
  Rate? bodyTemperature;
  Rate? weight;
  Rate? height;
  Rate? bmi;

  CurrentBioMetricsData({
    this.heartRate,
    this.oxygenLevel,
    this.bloodPressure,
    this.randomBloodSugar,
    this.fastingBloodSugar,
    this.bodyTemperature,
    this.weight,
    this.height,
    this.bmi,
  });
  factory CurrentBioMetricsData.fromJson(Map<String, dynamic> json) =>
      _$CurrentBioMetricsDataFromJson(json);
}

@JsonSerializable()
class Rate {
  String? value;
  String? date;

  Rate({this.value, this.date});

  factory Rate.fromJson(Map<String, dynamic> json) => _$RateFromJson(json);
  Map<String, dynamic> toJson() => _$RateToJson(this);
}
