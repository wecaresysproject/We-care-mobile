import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'upload_medical_report_response_model.g.dart';

@JsonSerializable()
class UploadMedicalReportResponseModel extends Equatable {
  final String? id;
  final String? fileName;
  final String? generatedAt;
  final String? url;

  const UploadMedicalReportResponseModel({
    this.id,
    this.fileName,
    this.generatedAt,
    this.url,
  });

  factory UploadMedicalReportResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$UploadMedicalReportResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UploadMedicalReportResponseModelToJson(this);

  @override
  List<Object?> get props => [id, fileName, generatedAt, url];
}
