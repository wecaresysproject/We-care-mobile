import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'medical_report_pdf_dates_response_model.g.dart';

@JsonSerializable()
class MedicalReportPdfDatesResponseModel extends Equatable {
  final List<String>? dates;

  const MedicalReportPdfDatesResponseModel({this.dates});

  factory MedicalReportPdfDatesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalReportPdfDatesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalReportPdfDatesResponseModelToJson(this);

  @override
  List<Object?> get props => [dates];
}
