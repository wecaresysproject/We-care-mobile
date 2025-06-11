import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/Biometrics/biometrics_data_entry/logic/cubit/biometrics_data_entry_state.dart';
import 'package:we_care/features/Biometrics/data/models/post_biometric_data_of_specifc_category_model.dart';
import 'package:we_care/features/Biometrics/data/repos/biometrics_data_entry_repo.dart';

class BiometricsDataEntryCubit extends Cubit<BiometricsDataEntryState> {
  BiometricsDataEntryCubit(this.biometricsDataEntryRepo)
      : super(
          BiometricsDataEntryState.initialState(),
        );

  final BiometricsDataEntryRepo biometricsDataEntryRepo;

  Future<void> postBiometricsDataEntry({
    required String categoryName,
    required String minValue,
    String? maxValue,
  }) async {
    emit(state.copyWith(submitBiometricDataStatus: RequestStatus.loading));

    final result = await biometricsDataEntryRepo.postBiometricsDataEntry(
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
          submitBiometricDataStatus: RequestStatus.success,
          message: successMessage,
        ),
      );
    }, failure: (failure) {
      emit(
        state.copyWith(
          submitBiometricDataStatus: RequestStatus.failure,
          message: failure.errors.first,
        ),
      );
    });
  }
}
