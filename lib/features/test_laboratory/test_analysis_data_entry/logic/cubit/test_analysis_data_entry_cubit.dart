import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/show_data_entry_types/data_entry_types_features/test_analysis_data_entry/Data/repos/test_analysis_data_entry_repo.dart';

part 'test_analysis_data_entry_state.dart';

class TestAnalysisDataEntryCubit extends Cubit<TestAnalysisDataEntryState> {
  TestAnalysisDataEntryCubit(this._testAnalysisDataEntryRepo)
      : super(
          TestAnalysisDataEntryState.initial(),
        );

  final TestAnalysisDataEntryRepo _testAnalysisDataEntryRepo;
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

//TODO: to be continue
  void updateSelectedCountry(String? selectedCountry) {
    emit(
      state.copyWith(
          // selectedCountryName: selectedCountry,
          ),
    );
  }

  void updateTestTypeWithAnnoation(String? type) {
    emit(
      state.copyWith(
        isTypeOfTestWithAnnotationSelected: type,
      ),
    );
    validateRequiredFields();
  }

  Future<void> emitCountriesData() async {
    final response = await _testAnalysisDataEntryRepo.getCountriesData(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            countriesNames: response.map((e) => e.name).toList(),
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
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
