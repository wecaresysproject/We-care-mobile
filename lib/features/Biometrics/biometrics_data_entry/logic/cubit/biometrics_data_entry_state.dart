import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';

@immutable
class BiometricsDataEntryState extends Equatable {
  final RequestStatus submitBiometricDataStatus;

  final bool isFormValidated;

  final bool isEditMode;
  final String message; // error or success message
  final ModuleGuidanceDataModel? moduleGuidanceData;

  const BiometricsDataEntryState({
    this.submitBiometricDataStatus = RequestStatus.initial,
    this.isFormValidated = false,
    this.message = '',
    this.isEditMode = false,
    this.moduleGuidanceData,
  }) : super();

  const BiometricsDataEntryState.initialState()
      : this(
          submitBiometricDataStatus: RequestStatus.initial,
          isFormValidated: false,
          message: '',
          isEditMode: false,
          moduleGuidanceData: null,
        );

  BiometricsDataEntryState copyWith({
    RequestStatus? submitBiometricDataStatus,
    bool? isFormValidated,
    String? message,
    bool? isEditMode,
    ModuleGuidanceDataModel? moduleGuidanceData,
  }) {
    return BiometricsDataEntryState(
      submitBiometricDataStatus:
          submitBiometricDataStatus ?? this.submitBiometricDataStatus,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      message: message ?? this.message,
      isEditMode: isEditMode ?? this.isEditMode,
      moduleGuidanceData: moduleGuidanceData ?? this.moduleGuidanceData,
    );
  }

  @override
  List<Object?> get props => [
        submitBiometricDataStatus,
        isFormValidated,
        isEditMode,
        message,
        moduleGuidanceData,
      ];
}
