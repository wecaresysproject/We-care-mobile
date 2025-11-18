import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_tooth_operation_details_by_id.g.dart';

@JsonSerializable()
class GetToothOpertionDetailsByIdResponseModel {
  bool success;
  String message;
  @JsonKey(name: 'data')
  ToothOperationDetails toothOperationDetails;

  GetToothOpertionDetailsByIdResponseModel(
      {required this.success,
      required this.message,
      required this.toothOperationDetails});

  factory GetToothOpertionDetailsByIdResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$GetToothOpertionDetailsByIdResponseModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$GetToothOpertionDetailsByIdResponseModelToJson(this);
}

@JsonSerializable()
class ToothOperationDetails {
  MedicalComplaints medicalComplaints;
  Procedure procedure;
  List<String> medicalReportImage;
  List<String> xRayImage;
  String lymphAnalysis;
  List<String> lymphAnalysisImage;
  String gumCondition;
  String treatingDoctor;
  String hospital;
  String country;
  String additionalNotes;
  String? writtenReport;

  ToothOperationDetails(
      {required this.medicalComplaints,
      required this.procedure,
      required this.medicalReportImage,
      required this.xRayImage,
      required this.lymphAnalysis,
      required this.lymphAnalysisImage,
      required this.gumCondition,
      required this.treatingDoctor,
      required this.hospital,
      required this.country,
      required this.additionalNotes});

  factory ToothOperationDetails.fromJson(Map<String, dynamic> json) =>
      _$ToothOperationDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$ToothOperationDetailsToJson(this);
}

@JsonSerializable()
class MedicalComplaints {
  String? symptomStartDate;
  String? symptomType;
  String? reasonExcpected;
  String? symptomDuration;
  String? complaintNature;
  String? painNature;

  MedicalComplaints({
    required this.symptomStartDate,
    required this.symptomType,
    required this.symptomDuration,
    required this.complaintNature,
    required this.reasonExcpected,
    required this.painNature,
  });
  factory MedicalComplaints.fromJson(Map<String, dynamic> json) =>
      _$MedicalComplaintsFromJson(json);
  Map<String, dynamic> toJson() => _$MedicalComplaintsToJson(this);
}

@JsonSerializable()
class Procedure {
  String? procedureDate;
  String? primaryProcedure;
  String? subProcedure;
  String? patientDescription;
  String? procedureType;
  String? painLevel;
  String? anesthesia;
  String? recoveryTime;

  Procedure(
      {required this.procedureDate,
      required this.primaryProcedure,
      required this.subProcedure,
      required this.patientDescription,
      required this.procedureType,
      required this.painLevel,
      required this.anesthesia,
      required this.recoveryTime});
  factory Procedure.fromJson(Map<String, dynamic> json) =>
      _$ProcedureFromJson(json);
  Map<String, dynamic> toJson() => _$ProcedureToJson(this);
}
