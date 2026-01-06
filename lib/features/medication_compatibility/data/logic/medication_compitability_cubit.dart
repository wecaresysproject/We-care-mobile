import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/features/nutration/nutration_data_entry/logic/deep_seek_services.dart';

part 'medication_compitability_state.dart';

class MedicationCompitabilityCubit extends Cubit<MedicationCompitabilityState> {
  MedicationCompitabilityCubit()
      : super(
          MedicationCompitabilityState.initialState(),
        );

  Future<void> analyzeMedicationCompitability() async {
    try {
      // Start loading
      emit(
        state.copyWith(
          requestStatus: RequestStatus.loading,
        ),
      );

      // Call ChatGPT service
      final result = await DeepSeekService.getMedicationCompitability();
      // if (nutritionData != null) {
      //   nutritionData.userDietplan = dietInput;
      // }
      // You can now use nutritionData to send to your backend
      // await postDailyDietPlan(
      //   nutritionData: nutritionData!,
      //   userDietplan: dietInput,
      // );
    } catch (e) {
      AppLogger.error('Error in analyzeDietPlan: $e');
      emit(
        state.copyWith(
          requestStatus: RequestStatus.failure,
          message: 'حدث خطأ أثناء تحليل البيانات الغذائية $e',
        ),
      );
    }
  }

  /// this method is used to emit state only if cubit is not closed
  void safeEmit(MedicationCompitabilityState newState) {
    if (!isClosed) emit(newState);
  }

  Future<void> fetchSystemPrompt() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    // final result = await _nutrationDataEntryRepo.fetchNutrationSystemPrompt();
    // result.when(
    //   success: (prompt) {
    //     emit(
    //       state.copyWith(
    //         requestStatus: RequestStatus.success,
    //         // systemPrompt: prompt,
    //       ),
    //     );
    //   },
    //   failure: (failure) {
    //     emit(
    //       state.copyWith(
    //         requestStatus: RequestStatus.failure,
    //         message: failure.errors.first,
    //       ),
    //     );
    //   },
    // );
  }
}
