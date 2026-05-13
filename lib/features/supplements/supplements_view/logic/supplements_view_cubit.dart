import 'package:bloc/bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/supplements/data/repos/supplements_view_repo.dart';

import 'supplements_view_state.dart';

class SupplementsViewCubit extends Cubit<SupplementsViewState> {
  SupplementsViewCubit(this._supplementsViewRepo, this.sharedRepo)
      : super(SupplementsViewState.initial());
  final SupplementsViewRepo _supplementsViewRepo;
  final AppSharedRepo sharedRepo;

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

  void setSelectedDate({required int tab, required String? date}) {
    AppLogger.info("SETTING DATE: $date for tab $tab");

    if (tab == 1) {
      emit(state.copyWith(selectedDateTab1: date));
    } else {
      emit(state.copyWith(selectedDateTab2: date));
    }
  }

  Future<void> fetchEffectsOnNutrients({String? range}) async {
    AppLogger.info("FETCHING EFFECTS ON NUTRIENTS: $range");
    emit(state.copyWith(effectsOnNutrientsStatus: RequestStatus.loading));
    final result = await _supplementsViewRepo.getEffectsOnNutrients(
      language: AppStrings.arabicLang,
      range: range,
    );
    result.when(
      success: (data) {
        AppLogger.info("EFFECTS ON NUTRIENTS: $data");
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

  Future<void> emitModuleGuidance() async {
    final result = await sharedRepo.getModuleGuidance(
      WeCareMedicalModules.vitaminsAndSupplementsView.name,
    );
    result.when(
      success: (data) {
        emit(
          state.copyWith(
            moduleGuidanceData: data,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            moduleGuidanceData: null,
          ),
        );
      },
    );
  }
}
