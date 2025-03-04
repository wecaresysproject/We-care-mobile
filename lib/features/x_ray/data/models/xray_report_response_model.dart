import 'package:freezed_annotation/freezed_annotation.dart';

part 'xray_report_response_model.g.dart';

@JsonSerializable()
class XrayReportResponseModel {
  final String reportUrl;
  @JsonKey(name: 'success')
  final bool isReportUploadedSuccessfully;
  final String message;

  XrayReportResponseModel({
    required this.reportUrl,
    required this.message,
    required this.isReportUploadedSuccessfully,
  });

  factory XrayReportResponseModel.fromJson(Map<String, dynamic> json) =>
      _$XrayReportResponseModelFromJson(json);
}
