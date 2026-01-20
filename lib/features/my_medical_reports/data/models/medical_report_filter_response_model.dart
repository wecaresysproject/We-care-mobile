import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_category_model.dart';

part 'medical_report_filter_response_model.g.dart';

@JsonSerializable()
class MedicalReportFilterResponseModel {
  final String title;
  final String image;
  final MedicalSelectionType selectionType;
  final List<String> radioOptions;
  final List<MedicalFilterSectionModel>? filterSections;

  MedicalReportFilterResponseModel({
    required this.title,
    required this.image,
    required this.selectionType,
    this.radioOptions = const [],
    this.filterSections,
  });

  factory MedicalReportFilterResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$MedicalReportFilterResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MedicalReportFilterResponseModelToJson(this);
}
