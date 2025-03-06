import 'package:json_annotation/json_annotation.dart';

part 'delete_analysis_document_response.g.dart';

@JsonSerializable()
class DeleteAnalysisDocumentResponse {
  bool success;
  String message;

  DeleteAnalysisDocumentResponse(
      {required this.success, required this.message});

  factory DeleteAnalysisDocumentResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteAnalysisDocumentResponseFromJson(json);
}
