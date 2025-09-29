import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/Biometrics/data/models/biometrics_dataset_model.dart';
import 'package:we_care/features/Biometrics/data/models/current_biometrics_data.dart';
import 'package:we_care/features/nutration/data/models/nutration_document_model.dart';
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

  Future<void> getAvailableDateRangesForWeeklyPlan() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response =
        await nutrationViewRepo.getAvailableDateRangesForWeeklyPlan(
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (data) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            weeklyPlanDateRangesFilter: data,
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

  Future<void> getAvailableDateRangesForMonthlyPlan() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response =
        await nutrationViewRepo.getAvailableDateRangesForMonthlyPlan(
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (data) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            monthlyPlanDateRangesFilter: data,
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
      getNutrationDocuments(),
      getAvailableYearsForWeeklyPlan(),
      getAvailableDateRangesForWeeklyPlan(),
      getAvailableDateRangesForMonthlyPlan(),
      getAvailableYearsForMonthlyPlan(),
    ]);
  }

  String _getPlanTypeNameRelativeToCurrentActiveTab() {
    return state.followUpNutrationViewCurrentTabIndex == 0
        ? PlanType.weekly.name
        : PlanType.monthly.name;
  }

  // New method to update the current tab index
  Future<void> updateCurrentTab(int index) async {
    emit(state.copyWith(followUpNutrationViewCurrentTabIndex: index));
    await getNutrationDocuments();
  }

  Future<void> getNutrationDocuments() async {
    final currentPlanType = _getPlanTypeNameRelativeToCurrentActiveTab();
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await nutrationViewRepo.getNutrationDocuments(
      language: AppStrings.arabicLang,
      planType: currentPlanType,
    );
    response.when(
      success: (data) {
        if (currentPlanType == PlanType.weekly.name) {
          emit(
            state.copyWith(
              requestStatus: RequestStatus.success,
              weeklyNutrationDocuments: data,
            ),
          );
          AppLogger.info(
            'Weekly Nutration Documents: ${state.weeklyNutrationDocuments.length}',
          );
        } else {
          emit(
            state.copyWith(
              requestStatus: RequestStatus.success,
              monthlyNutrationDocuments: data,
            ),
          );
          AppLogger.info(
            'Monthly Nutration Documents: ${state.monthlyNutrationDocuments.length}',
          );
        }
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
}
