import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
import 'package:we_care/features/medication_compatibility/data/models/clinical_audit_report_model.dart';
import 'package:we_care/features/medicine/data/models/user_medical_history_details_model.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_filter_response_model.dart';

class MedicinesCompatibilityState extends Equatable {
  final RequestStatus status;
  final MedicalReportFilterResponseModel? filterData;
  final String message;
  final ModuleGuidanceDataModel? moduleGuidanceData;
  final UserMedicalHistoryDetailsModel? userMedicalProfileHistory;
  final RequestStatus medicalHistoryStatus;

  // New fields for Medicines Compatibility
  final List<String> selectedMedicines;
  final List<String> recentlyExpiredMedicines;
  final RequestStatus analysisStatus;
  final ClinicalAuditReportModel? auditReport;
  final RequestStatus fetchSystemPromptStatus;
  final String? medicalCompitabilitySystemPrompt;

  const MedicinesCompatibilityState({
    this.status = RequestStatus.initial,
    this.filterData,
    this.message = '',
    this.moduleGuidanceData,
    this.userMedicalProfileHistory,
    this.medicalHistoryStatus = RequestStatus.initial,
    this.selectedMedicines = const [],
    this.recentlyExpiredMedicines = const [],
    this.analysisStatus = RequestStatus.initial,
    this.auditReport,
    this.fetchSystemPromptStatus = RequestStatus.initial,
    this.medicalCompitabilitySystemPrompt,
  });

  MedicinesCompatibilityState copyWith({
    RequestStatus? status,
    MedicalReportFilterResponseModel? filterData,
    String? message,
    ModuleGuidanceDataModel? moduleGuidanceData,
    UserMedicalHistoryDetailsModel? userMedicalProfileHistory,
    RequestStatus? medicalHistoryStatus,
    List<String>? selectedMedicines,
    List<String>? recentlyExpiredMedicines,
    RequestStatus? analysisStatus,
    ClinicalAuditReportModel? auditReport,
    RequestStatus? fetchSystemPromptStatus,
    String? medicalCompitabilitySystemPrompt,
  }) {
    return MedicinesCompatibilityState(
      status: status ?? this.status,
      filterData: filterData ?? this.filterData,
      message: message ?? this.message,
      moduleGuidanceData: moduleGuidanceData ?? this.moduleGuidanceData,
      userMedicalProfileHistory:
          userMedicalProfileHistory ?? this.userMedicalProfileHistory,
      medicalHistoryStatus: medicalHistoryStatus ?? this.medicalHistoryStatus,
      selectedMedicines: selectedMedicines ?? this.selectedMedicines,
      recentlyExpiredMedicines:
          recentlyExpiredMedicines ?? this.recentlyExpiredMedicines,
      analysisStatus: analysisStatus ?? this.analysisStatus,
      auditReport: auditReport ?? this.auditReport,
      fetchSystemPromptStatus:
          fetchSystemPromptStatus ?? this.fetchSystemPromptStatus,
      medicalCompitabilitySystemPrompt: medicalCompitabilitySystemPrompt ??
          this.medicalCompitabilitySystemPrompt,
    );
  }

  @override
  List<Object?> get props => [
        status,
        filterData,
        message,
        moduleGuidanceData,
        userMedicalProfileHistory,
        medicalHistoryStatus,
        selectedMedicines,
        recentlyExpiredMedicines,
        analysisStatus,
        auditReport,
        fetchSystemPromptStatus,
        medicalCompitabilitySystemPrompt,
      ];
}
