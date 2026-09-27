import 'package:json_annotation/json_annotation.dart';

part 'membership_model.g.dart';

@JsonSerializable()
class MembershipModel {
  final String countryName;
  final String associationName;
  final String membershipNumber;
  final String membershipLevel;
  final String year;

  MembershipModel({
    required this.countryName,
    required this.associationName,
    required this.membershipNumber,
    required this.membershipLevel,
    required this.year,
  });

  Map<String, dynamic> toJson() => _$MembershipModelToJson(this);
}
