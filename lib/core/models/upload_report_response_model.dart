import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_report_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UploadReportResponseModel {
  final String reportUrl;
  @JsonKey(name: 'success')
  final bool isReportUploadedSuccessfully;
  final String message;

  UploadReportResponseModel({
    required this.reportUrl,
    required this.message,
    required this.isReportUploadedSuccessfully,
  });

  factory UploadReportResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UploadReportResponseModelFromJson(json);
}
