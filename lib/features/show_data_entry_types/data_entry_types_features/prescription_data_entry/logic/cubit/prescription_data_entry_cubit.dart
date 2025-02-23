import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';

part 'prescription_data_entry_state.dart';

class PrescriptionDataEntryCubit extends Cubit<PrescriptionDataEntryState> {
  PrescriptionDataEntryCubit()
      : super(
          PrescriptionDataEntryState.initialState(),
        );

  final personalNotesController = TextEditingController();

  /// Update Field Values
  void updatePrescriptionDate(String? date) {
    emit(state.copyWith(preceriptionDateSelection: date));
    validateRequiredFields();
  }

  void updateXRayBodyPart(String? bodyPart) {
    emit(state.copyWith(xRayBodyPartSelection: bodyPart));
    validateRequiredFields();
  }

  void updateXRayType(String? type) {
    emit(state.copyWith(xRayTypeSelection: type));
    validateRequiredFields();
  }

  void updateXRayPicture(bool? isImagePicked) {
    emit(state.copyWith(isXRayPictureSelected: isImagePicked));
    validateRequiredFields();
  }

  /// state.isXRayPictureSelected == false => image rejected
  void validateRequiredFields() {
    if (state.preceriptionDateSelection == null ||
        state.xRayBodyPartSelection == null ||
        state.xRayTypeSelection == null ||
        state.isXRayPictureSelected == null ||
        state.isXRayPictureSelected == false) {
      emit(
        state.copyWith(
          isFormValidated: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isFormValidated: true,
        ),
      );
    }
  }
}
