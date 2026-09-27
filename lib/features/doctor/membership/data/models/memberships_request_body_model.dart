import 'package:we_care/features/doctor/membership/data/models/membership_model.dart';

class MembershipsRequestBodyModel {
  final List<MembershipModel> memberships;

  MembershipsRequestBodyModel({required this.memberships});

  Map<String, dynamic> toJson() => {
        'memberships':
            memberships.map((membership) => membership.toJson()).toList(),
      };
}
