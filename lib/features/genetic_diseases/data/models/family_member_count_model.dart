import 'package:json_annotation/json_annotation.dart';

part 'family_member_count_model.g.dart';

@JsonSerializable()
class FamilyMemberCount {
  final int mam;
  final int dad;
  final int grandpaFather;
  final int grandmaFather;
  final int grandpaMother;
  final int grandmaMother;
  final int bro;
  final int sis;
  final int fatherSideUncle;
  final int fatherSideAunt;
  final int motherSideUncle;
  final int motherSideAunt;

  const FamilyMemberCount({
    required this.mam,
    required this.dad,
    required this.grandpaFather,
    required this.grandmaFather,
    required this.grandpaMother,
    required this.grandmaMother,
    required this.bro,
    required this.sis,
    required this.fatherSideUncle,
    required this.fatherSideAunt,
    required this.motherSideUncle,
    required this.motherSideAunt,
  });

  factory FamilyMemberCount.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberCountFromJson(json);

  Map<String, dynamic> toJson() => _$FamilyMemberCountToJson(this);
}
