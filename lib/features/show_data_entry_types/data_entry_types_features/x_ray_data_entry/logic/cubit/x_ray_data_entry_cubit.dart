import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';

part 'x_ray_data_entry_state.dart';

class XRayDataEntryCubit extends Cubit<XRayDataEntryState> {
  XRayDataEntryCubit()
      : super(
          XRayDataEntryState.initialState(),
        );

  final personalNotesController = TextEditingController();

  /// Update Field Values
  void updateXRayDate(String? date) {
    emit(state.copyWith(xRayDateSelection: date));
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
    if (state.xRayDateSelection == null ||
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
