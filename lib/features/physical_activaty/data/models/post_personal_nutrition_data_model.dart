import 'package:json_annotation/json_annotation.dart';

part 'post_personal_nutrition_data_model.g.dart';

@JsonSerializable()
class PostPersonalUserInfoData {
  final int weight;
  final int height;
  final int age;
  final String gender;
  final String physicalActivity;
  final List<String>? chronicDisease;

  PostPersonalUserInfoData({
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.physicalActivity,
    required this.chronicDisease,
  });

  factory PostPersonalUserInfoData.fromJson(Map<String, dynamic> json) =>
      _$PostPersonalUserInfoDataFromJson(json);

  Map<String, dynamic> toJson() => _$PostPersonalUserInfoDataToJson(this);
}
