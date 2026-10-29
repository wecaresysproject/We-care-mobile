import 'package:we_care/features/doctor/research_and_papers/data/models/research_paper_model.dart';

class ResearchPapersRequestBodyModel {
  final List<ResearchPaperModel> researchPapers;

  ResearchPapersRequestBodyModel({required this.researchPapers});

  factory ResearchPapersRequestBodyModel.fromJson(Map<String, dynamic> json) =>
      ResearchPapersRequestBodyModel(
        researchPapers: (json['researchPapers'] as List? ?? const [])
            .map((e) => ResearchPaperModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'researchPapers':
            researchPapers.map((paper) => paper.toJson()).toList(),
      };
}
