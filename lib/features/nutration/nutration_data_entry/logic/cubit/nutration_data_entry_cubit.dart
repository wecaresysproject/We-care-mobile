import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/Biometrics/data/models/post_biometric_data_of_specifc_category_model.dart';
import 'package:we_care/features/nutration/data/repos/nutration_data_entry_repo.dart';

part 'nutration_data_entry_state.dart';

class NutrationDataEntryCubit extends Cubit<NutrationDataEntryState> {
  NutrationDataEntryCubit(this._nutrationDataEntryRepo)
      : super(
          NutrationDataEntryState.initialState(),
        );

  final NutrationDataEntryRepo _nutrationDataEntryRepo;

  Future<void> postNutrationDataEntry({
    required String categoryName,
    required String minValue,
    String? maxValue,
  }) async {
    emit(state.copyWith(submitNutrationDataStatus: RequestStatus.loading));

    final result = await _nutrationDataEntryRepo.postNutrationDataEntry(
      requestBody: PostBiometricCategoryModel(
        categoryName: categoryName,
        minValue: minValue,
        maxValue:
            maxValue, //should handle in case there was an max an min value
      ),
      lanugage: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );
    result.when(success: (successMessage) {
      emit(
        state.copyWith(
          submitNutrationDataStatus: RequestStatus.success,
          message: successMessage,
        ),
      );
    }, failure: (failure) {
      emit(
        state.copyWith(
          submitNutrationDataStatus: RequestStatus.failure,
          message: failure.errors.first,
        ),
      );
    });
  }
}
