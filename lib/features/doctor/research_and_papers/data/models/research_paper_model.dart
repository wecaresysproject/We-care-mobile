import 'package:json_annotation/json_annotation.dart';

part 'research_paper_model.g.dart';

@JsonSerializable()
class ResearchPaperModel {
  final String title;
  final String year;
  final String doiOrLink;

  ResearchPaperModel({
    required this.title,
    required this.year,
    required this.doiOrLink,
  });

  Map<String, dynamic> toJson() => _$ResearchPaperModelToJson(this);
}
