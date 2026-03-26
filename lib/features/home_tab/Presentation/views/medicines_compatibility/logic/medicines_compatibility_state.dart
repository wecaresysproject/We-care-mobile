import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
import 'package:we_care/features/medicine/data/models/user_medical_history_details_model.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_filter_response_model.dart';

class MedicinesCompatibilityState extends Equatable {
  final RequestStatus status;
  final MedicalReportFilterResponseModel? filterData;
  final String message;
  final ModuleGuidanceDataModel? moduleGuidanceData;
  final UserMedicalHistoryDetailsModel? userMedicalProfileHistory;
  final RequestStatus medicalHistoryStatus;
  const MedicinesCompatibilityState({
    this.status = RequestStatus.initial,
    this.filterData,
    this.message = '',
    this.moduleGuidanceData,
    this.userMedicalProfileHistory,
    this.medicalHistoryStatus = RequestStatus.initial,
  });

  MedicinesCompatibilityState copyWith({
    RequestStatus? status,
    MedicalReportFilterResponseModel? filterData,
    String? message,
    ModuleGuidanceDataModel? moduleGuidanceData,
    UserMedicalHistoryDetailsModel? userMedicalProfileHistory,
    RequestStatus? medicalHistoryStatus,
  }) {
    return MedicinesCompatibilityState(
      status: status ?? this.status,
      filterData: filterData ?? this.filterData,
      message: message ?? this.message,
      moduleGuidanceData: moduleGuidanceData ?? this.moduleGuidanceData,
      userMedicalProfileHistory:
          userMedicalProfileHistory ?? this.userMedicalProfileHistory,
      medicalHistoryStatus: medicalHistoryStatus ?? this.medicalHistoryStatus,
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
      ];
}
