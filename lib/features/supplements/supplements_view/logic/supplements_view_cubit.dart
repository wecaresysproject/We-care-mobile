import 'package:bloc/bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/supplements/data/repos/supplements_view_repo.dart';

import 'supplements_view_state.dart';

class SupplementsViewCubit extends Cubit<SupplementsViewState> {
  SupplementsViewCubit(this._supplementsViewRepo)
      : super(SupplementsViewState.initial());
  final SupplementsViewRepo _supplementsViewRepo;

  Future<void> getAvailableDateRanges() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _supplementsViewRepo.getAvailableDateRanges(
      language: AppStrings.arabicLang,
    );
    result.when(
      success: (dates) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            availableDateRanges: dates,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.failure,
            responseMessage: failure.errors.first,
          ),
        );
      },
    );
  }

  Future<void> fetchEffectsOnNutrients({String? range}) async {
    emit(state.copyWith(effectsOnNutrientsStatus: RequestStatus.loading));
    final result = await _supplementsViewRepo.getEffectsOnNutrients(
      language: AppStrings.arabicLang,
      range: range,
    );
    result.when(
      success: (data) {
        emit(
          state.copyWith(
            effectsOnNutrientsStatus: RequestStatus.success,
            effectsOnNutrientsList: data,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            effectsOnNutrientsStatus: RequestStatus.failure,
            responseMessage: failure.errors.first,
          ),
        );
      },
    );
  }

  Future<void> fetchVitaminsAndSupplements({String? range}) async {
    emit(state.copyWith(vitaminsAndSupplementsStatus: RequestStatus.loading));
    final result = await _supplementsViewRepo.getVitaminsAndSupplements(
      language: AppStrings.arabicLang,
      range: range,
    );
    result.when(
      success: (data) {
        emit(
          state.copyWith(
            vitaminsAndSupplementsStatus: RequestStatus.success,
            vitaminsAndSupplementsData: data,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            vitaminsAndSupplementsStatus: RequestStatus.failure,
            responseMessage: failure.errors.first,
          ),
        );
      },
    );
  }
}
