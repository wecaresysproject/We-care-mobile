import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_filter_response_model.dart';

class MedicinesCompatibilityState extends Equatable {
  final RequestStatus status;
  final MedicalReportFilterResponseModel? filterData;
  final String message;
  final ModuleGuidanceDataModel? moduleGuidanceData;

  const MedicinesCompatibilityState({
    this.status = RequestStatus.initial,
    this.filterData,
    this.message = '',
    this.moduleGuidanceData,
  });

  MedicinesCompatibilityState copyWith({
    RequestStatus? status,
    MedicalReportFilterResponseModel? filterData,
    String? message,
    ModuleGuidanceDataModel? moduleGuidanceData,
  }) {
    return MedicinesCompatibilityState(
      status: status ?? this.status,
      filterData: filterData ?? this.filterData,
      message: message ?? this.message,
      moduleGuidanceData: moduleGuidanceData ?? this.moduleGuidanceData,
    );
  }

  @override
  List<Object?> get props => [
        status,
        filterData,
        message,
        moduleGuidanceData,
      ];
}
