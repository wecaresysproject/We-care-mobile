

import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_tooth_documents_reponse_model.g.dart';

@JsonSerializable()
class GetToothDocumentsResponseModel {
  bool success;
  String message;
@JsonKey(name: 'data')
  List<ToothDocument> toothDocuments;

  GetToothDocumentsResponseModel({
    required this.success,
    required this.message,
    required this.toothDocuments,
  });

  factory GetToothDocumentsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetToothDocumentsResponseModelFromJson(json);
}
@JsonSerializable()
class ToothDocument {
  String? id; 
  String? symptomStartDate; 
  String? painNature; 
  String? teethNumber; 
  String? primaryProcedure; 

 ToothDocument({
    this.id,
    this.symptomStartDate,
    this.painNature,
    this.teethNumber,
    this.primaryProcedure,
  });

  factory ToothDocument.fromJson(Map<String, dynamic> json) =>
      _$ToothDocumentFromJson(json);
}