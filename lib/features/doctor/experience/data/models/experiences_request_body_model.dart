import 'package:we_care/features/doctor/experience/data/models/experience_model.dart';

class ExperiencesRequestBodyModel {
  final List<ExperienceModel> experiences;

  ExperiencesRequestBodyModel({required this.experiences});

  Map<String, dynamic> toJson() => {
        'experiences':
            experiences.map((experience) => experience.toJson()).toList(),
      };
}
