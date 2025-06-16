import 'package:json_annotation/json_annotation.dart';

part 'family_members_model.g.dart';

@JsonSerializable()
class FamilyMembersModel {
  @JsonKey(name: 'isFirstTime')
  final bool isFirstTimeAnsweredFamilyMembersQuestions;
  @JsonKey(name: 'Bro')
  final int numberOfBrothers;

  @JsonKey(name: 'Sis')
  final int numberOfSisters;

  @JsonKey(name: 'FatherSideUncle')
  final int numberOfFatherSideUncles;

  @JsonKey(name: 'FatherSideAunt')
  final int numberOfFatherSideAunts;

  @JsonKey(name: 'MotherSideUncle')
  final int numberOfMotherSideUncles;

  @JsonKey(name: 'MotherSideAunt')
  final int numberOfMotherSideAunts;

  const FamilyMembersModel({
    required this.isFirstTimeAnsweredFamilyMembersQuestions,
    required this.numberOfBrothers,
    required this.numberOfSisters,
    required this.numberOfFatherSideUncles,
    required this.numberOfFatherSideAunts,
    required this.numberOfMotherSideUncles,
    required this.numberOfMotherSideAunts,
  });

  factory FamilyMembersModel.fromJson(Map<String, dynamic> json) =>
      _$FamilyMembersModelFromJson(json);

  Map<String, dynamic> toJson() => _$FamilyMembersModelToJson(this);
}
