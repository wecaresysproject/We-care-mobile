
import 'package:json_annotation/json_annotation.dart';

part 'get_family_members_names.g.dart';

@JsonSerializable()
class GetFamilyMembersNames {
  @JsonKey(name: 'Bro')
  List<String>? bro;
  @JsonKey(name: 'Sis')
	List<String>? sis;
  @JsonKey(name: 'Mam')
	List<String>? mother;
  @JsonKey(name: 'Dad')
	List<String>?father;
  @JsonKey(name: 'GrandpaFather')
	List<String>? grandpaFather;
  @JsonKey(name: 'GrandmaFather')
	List<String>? grandmaFather;
  @JsonKey(name: 'GrandpaMother')
  List<String>? grandpaMother;
  @JsonKey(name: 'GrandmaMother')
	List<String>? grandmaMother;
  @JsonKey(name: 'MotherSideAunt')
	List<String>? motherSideAunt;
  @JsonKey(name: 'MotherSideUncle')
	List<String>? motherSideUncle;
  @JsonKey(name: 'FatherSideAunt')
	List<String>? fatherSideAunt;
  @JsonKey(name: 'FatherSideUncle')
	List<String>?fatherSideUncle;

  GetFamilyMembersNames({
    this.bro,
    this.sis,
    this.mother,
    this.father,
    this.grandpaFather,
    this.grandmaFather,
    this.grandpaMother,
    this.grandmaMother,
    this.motherSideAunt,
    this.motherSideUncle,
    this.fatherSideAunt,
    this.fatherSideUncle,
  });
  factory GetFamilyMembersNames.fromJson(Map<String, dynamic> json) =>
      _$GetFamilyMembersNamesFromJson(json);

  Map<String, dynamic> toJson() => _$GetFamilyMembersNamesToJson(this);

}