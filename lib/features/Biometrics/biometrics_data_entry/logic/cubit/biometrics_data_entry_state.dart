import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';

@immutable
class BiometricsDataEntryState extends Equatable {
  final RequestStatus submitBiometricDataStatus;

  final bool isFormValidated;

  final bool isEditMode;
  final String message; // error or success message

  const BiometricsDataEntryState({
    this.submitBiometricDataStatus = RequestStatus.initial,
    this.isFormValidated = false,
    this.message = '',
    this.isEditMode = false,
  }) : super();

  const BiometricsDataEntryState.initialState()
      : this(
          submitBiometricDataStatus: RequestStatus.initial,
          isFormValidated: false,
          message: '',
          isEditMode: false,
        );

  BiometricsDataEntryState copyWith({
    RequestStatus? submitBiometricDataStatus,
    bool? isFormValidated,
    String? message,
    bool? isEditMode,
  }) {
    return BiometricsDataEntryState(
      submitBiometricDataStatus:
          submitBiometricDataStatus ?? this.submitBiometricDataStatus,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      message: message ?? this.message,
      isEditMode: isEditMode ?? this.isEditMode,
    );
  }

  @override
  List<Object?> get props => [
        submitBiometricDataStatus,
        isFormValidated,
        isEditMode,
        message,
      ];
}
