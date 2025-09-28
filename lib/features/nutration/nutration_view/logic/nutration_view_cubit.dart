import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/Biometrics/data/models/biometrics_dataset_model.dart';
import 'package:we_care/features/Biometrics/data/models/current_biometrics_data.dart';
import 'package:we_care/features/nutration/data/repos/nutration_view_repo.dart';

part 'nutration_view_state.dart';

class NutrationViewCubit extends Cubit<NutrationViewState> {
  NutrationViewCubit(this.nutrationViewRepo)
      : super(NutrationViewState.initial());
  final NutrationViewRepo nutrationViewRepo;
  Future<void> getAvailableYearsForWeeklyPlan() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await nutrationViewRepo.getAvailableYearsForWeeklyPlan(
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (data) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            weaklyPlanYearsFilter: data,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> getAvailableYearsForMonthlyPlan() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await nutrationViewRepo.getAvailableYearsForMonthlyPlan(
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (data) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            monthlyPlanYearsFilter: data,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> getIntialRequests() async {
    await Future.wait([
      getAvailableYearsForWeeklyPlan(),
      getAvailableYearsForMonthlyPlan(),
    ]);
  }
  // Future<void> getAllAvailableBiometrics() async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));

  //   final response = await nutrationViewRepo.getAllAvailableBiometrics(
  //       language: 'ar', userType: 'Patient');
  //   response.when(
  //     success: (data) {
  //       emit(state.copyWith(
  //         requestStatus: RequestStatus.success,
  //         availableBiometricNames: data,
  //       ));
  //     },
  //     failure: (error) {
  //       emit(state.copyWith(
  //         requestStatus: RequestStatus.failure,
  //       ));
  //     },
  //   );
  // }

  // Future<void> getAllFilters() async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));

  //   final response = await nutrationViewRepo.getAllFilters(
  //       language: 'ar', userType: 'Patient');
  //   response.when(
  //     success: (data) {
  //       emit(state.copyWith(
  //         requestStatus: RequestStatus.success,
  //         yearsFilter: data.years,
  //         daysFilter: data.days,
  //         monthFilter: data.months,
  //       ));
  //     },
  //     failure: (error) {
  //       emit(state.copyWith(
  //         requestStatus: RequestStatus.failure,
  //       ));
  //     },
  //   );
  // }

  // Future<void> getFilteredBiometrics({
  //   int? year,
  //   int? month,
  //   int? day,
  //   required List<String> biometricCategories,
  // }) async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));

  //   final response = await nutrationViewRepo.getFilteredBiometrics(
  //       language: 'ar',
  //       userType: 'Patient',
  //       year: year,
  //       month: month,
  //       day: day,
  //       biometricCategories: biometricCategories);
  //   response.when(
  //     success: (data) {
  //       emit(state.copyWith(
  //         requestStatus: RequestStatus.success,
  //         biometricsData: data,
  //       ));
  //     },
  //     failure: (error) {
  //       emit(state.copyWith(
  //         requestStatus: RequestStatus.failure,
  //       ));
  //     },
  //   );
  // }

  // Future<void> getCurrentBiometricData() async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));

  //   final response = await nutrationViewRepo.getCurrentBiometricData(
  //       language: 'ar', userType: 'Patient');
  //   response.when(
  //     success: (data) {
  //       emit(state.copyWith(
  //         requestStatus: RequestStatus.success,
  //         currentBiometricsData: data,
  //       ));
  //     },
  //     failure: (error) {
  //       emit(state.copyWith(
  //         requestStatus: RequestStatus.failure,
  //       ));
  //     },
  //   );
  // }
}
