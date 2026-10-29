import 'package:we_care/features/doctor/experience/data/models/experience_model.dart';

class ExperiencesRequestBodyModel {
  final List<ExperienceModel> experiences;

  ExperiencesRequestBodyModel({required this.experiences});

  factory ExperiencesRequestBodyModel.fromJson(Map<String, dynamic> json) =>
      ExperiencesRequestBodyModel(
        experiences: (json['experiences'] as List? ?? const [])
            .map((e) => ExperienceModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'experiences':
            experiences.map((experience) => experience.toJson()).toList(),
      };
}
