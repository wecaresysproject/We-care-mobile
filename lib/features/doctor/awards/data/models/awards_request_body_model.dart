import 'package:we_care/features/doctor/awards/data/models/award_model.dart';

class AwardsRequestBodyModel {
  final List<AwardModel> awards;

  AwardsRequestBodyModel({required this.awards});

  Map<String, dynamic> toJson() => {
        'awards': awards.map((award) => award.toJson()).toList(),
      };
}
