import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clinical_audit_report_model.g.dart';

@JsonSerializable()
class ClinicalAuditReportModel extends Equatable {
  final ClinicalAuditReport clinicalAuditReport;

  const ClinicalAuditReportModel({
    required this.clinicalAuditReport,
  });

  factory ClinicalAuditReportModel.fromJson(Map<String, dynamic> json) =>
      _$ClinicalAuditReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClinicalAuditReportModelToJson(this);

  @override
  List<Object?> get props => [clinicalAuditReport];
}

@JsonSerializable()
class ClinicalAuditReport extends Equatable {
  final ChemicalInteractionMatrix chemicalInteractionMatrix;
  final SystemicCompatibility systemicCompatibility;
  final DoctorDiscussion doctorDiscussion;

  const ClinicalAuditReport({
    required this.chemicalInteractionMatrix,
    required this.systemicCompatibility,
    required this.doctorDiscussion,
  });

  factory ClinicalAuditReport.fromJson(Map<String, dynamic> json) =>
      _$ClinicalAuditReportFromJson(json);

  Map<String, dynamic> toJson() => _$ClinicalAuditReportToJson(this);

  @override
  List<Object?> get props => [
        chemicalInteractionMatrix,
        systemicCompatibility,
        doctorDiscussion,
      ];
}

@JsonSerializable()
class ChemicalInteractionMatrix extends Equatable {
  @JsonKey(defaultValue: [])
  final List<ChemicalItem> antagonism;

  @JsonKey(defaultValue: [])
  final List<ChemicalItem> synergy;

  @JsonKey(defaultValue: [])
  final List<ChemicalItem> pastDrugResiduals;

  const ChemicalInteractionMatrix({
    required this.antagonism,
    required this.synergy,
    required this.pastDrugResiduals,
  });

  factory ChemicalInteractionMatrix.fromJson(Map<String, dynamic> json) =>
      _$ChemicalInteractionMatrixFromJson(json);

  Map<String, dynamic> toJson() => _$ChemicalInteractionMatrixToJson(this);

  @override
  List<Object?> get props => [antagonism, synergy, pastDrugResiduals];
}

@JsonSerializable()
class ChemicalItem extends Equatable {
  final String title;
  final String description;
  final String riskLevel;

  final String action; // ✅ مهم جداً من PDF

  @JsonKey(defaultValue: [])
  final List<String> drugsInvolved;

  const ChemicalItem({
    required this.title,
    required this.description,
    required this.riskLevel,
    required this.action,
    required this.drugsInvolved,
  });

  factory ChemicalItem.fromJson(Map<String, dynamic> json) =>
      _$ChemicalItemFromJson(json);

  Map<String, dynamic> toJson() => _$ChemicalItemToJson(this);

  @override
  List<Object?> get props =>
      [title, description, riskLevel, action, drugsInvolved];
}

@JsonSerializable()
class SystemicCompatibility extends Equatable {
  @JsonKey(defaultValue: [])
  final List<SystemicItem> foodAndSupplements;

  @JsonKey(defaultValue: [])
  final List<SystemicItem> organSafety;

  @JsonKey(defaultValue: [])
  final List<SystemicItem> behavioralImpact;

  const SystemicCompatibility({
    required this.foodAndSupplements,
    required this.organSafety,
    required this.behavioralImpact,
  });

  factory SystemicCompatibility.fromJson(Map<String, dynamic> json) =>
      _$SystemicCompatibilityFromJson(json);

  Map<String, dynamic> toJson() => _$SystemicCompatibilityToJson(this);

  @override
  List<Object?> get props =>
      [foodAndSupplements, organSafety, behavioralImpact];
}

@JsonSerializable()
class SystemicItem extends Equatable {
  final String title;
  final String description;
  final String riskLevel;

  final String action; // ✅ مهم

  @JsonKey(defaultValue: [])
  final List<String> relatedItems;

  const SystemicItem({
    required this.title,
    required this.description,
    required this.riskLevel,
    required this.action,
    required this.relatedItems,
  });

  factory SystemicItem.fromJson(Map<String, dynamic> json) =>
      _$SystemicItemFromJson(json);

  Map<String, dynamic> toJson() => _$SystemicItemToJson(this);

  @override
  List<Object?> get props =>
      [title, description, riskLevel, action, relatedItems];
}

@JsonSerializable()
class DoctorDiscussion extends Equatable {
  @JsonKey(defaultValue: [])
  final List<RiskLevelItem> riskTable;

  @JsonKey(defaultValue: [])
  final List<String> questions;

  const DoctorDiscussion({
    required this.riskTable,
    required this.questions,
  });

  factory DoctorDiscussion.fromJson(Map<String, dynamic> json) =>
      _$DoctorDiscussionFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorDiscussionToJson(this);

  @override
  List<Object?> get props => [riskTable, questions];
}

@JsonSerializable()
class RiskLevelItem extends Equatable {
  final String level; // L1, L2...
  final String meaning; // المعنى
  final String action; // الإجراء

  const RiskLevelItem({
    required this.level,
    required this.meaning,
    required this.action,
  });

  factory RiskLevelItem.fromJson(Map<String, dynamic> json) =>
      _$RiskLevelItemFromJson(json);

  Map<String, dynamic> toJson() => _$RiskLevelItemToJson(this);

  @override
  List<Object?> get props => [level, meaning, action];
}
