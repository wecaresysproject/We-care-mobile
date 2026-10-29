import 'package:we_care/features/doctor/awards/data/models/award_model.dart';

class AwardsRequestBodyModel {
  final List<AwardModel> awards;

  AwardsRequestBodyModel({required this.awards});

  factory AwardsRequestBodyModel.fromJson(Map<String, dynamic> json) =>
      AwardsRequestBodyModel(
        awards: (json['awards'] as List? ?? const [])
            .map((e) => AwardModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'awards': awards.map((award) => award.toJson()).toList(),
      };
}
