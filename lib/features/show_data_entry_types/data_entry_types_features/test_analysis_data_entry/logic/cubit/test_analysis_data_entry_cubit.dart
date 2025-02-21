import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';

part 'test_analysis_data_entry_state.dart';

class TestAnalysisDataEntryCubit extends Cubit<TestAnalysisDataEntryState> {
  TestAnalysisDataEntryCubit()
      : super(
          TestAnalysisDataEntryState.initial(),
        );

  void updateTestDate(String? date) {
    emit(
      state.copyWith(
        isDateSelected: date,
      ),
    );
    validateRequiredFields();
  }

  void updateTestPicture(bool? isImagePicked) {
    emit(
      state.copyWith(
        isTestPictureSelected: isImagePicked,
      ),
    );
    validateRequiredFields();
  }

  void updateTestType(String? type) {
    emit(
      state.copyWith(
        isTypeOfTestSelected: type,
      ),
    );
    validateRequiredFields();
  }

  void updateTestTypeWithAnnoation(String? type) {
    emit(
      state.copyWith(
        isTypeOfTestWithAnnotationSelected: type,
      ),
    );
    validateRequiredFields();
  }

  void validateRequiredFields() {
    if (state.isDateSelected == null ||
        state.isTestPictureSelected == null ||
        state.isTestPictureSelected == false ||
        (state.isTypeOfTestSelected == null &&
            state.isTypeOfTestWithAnnotationSelected == null)) {
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
