import 'package:we_care/features/doctor/membership/data/models/membership_model.dart';

class MembershipsRequestBodyModel {
  final List<MembershipModel> memberships;

  MembershipsRequestBodyModel({required this.memberships});

  factory MembershipsRequestBodyModel.fromJson(Map<String, dynamic> json) =>
      MembershipsRequestBodyModel(
        memberships: (json['memberships'] as List? ?? const [])
            .map((e) => MembershipModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'memberships':
            memberships.map((membership) => membership.toJson()).toList(),
      };
}
