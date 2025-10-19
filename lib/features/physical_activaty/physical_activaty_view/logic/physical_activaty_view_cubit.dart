import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/nutration/data/models/element_recommendation_response_model.dart';
import 'package:we_care/features/nutration/data/models/food_alternative_category_model.dart';
import 'package:we_care/features/nutration/data/models/nutration_document_model.dart';
import 'package:we_care/features/nutration/data/models/organ_nutritional_effects_response_model.dart';
import 'package:we_care/features/physical_activaty/data/repos/physical_activaty_view_repo.dart';

part 'physical_activaty_view_state.dart';

class PhysicalActivityViewCubit extends Cubit<PhysicalActivatyViewState> {
  PhysicalActivityViewCubit(this.physicalActivatyViewRepo)
      : super(PhysicalActivatyViewState.initial());
  final PhysicalActivatyViewRepo physicalActivatyViewRepo;
  Future<void> getAvailableYearsForWeeklyPlan() async {
    final response =
        await physicalActivatyViewRepo.getAvailableYearsForWeeklyPlan(
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (data) {
        emit(
          state.copyWith(
            weaklyPlanYearsFilter: data,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(),
        );
      },
    );
  }

  Future<void> getAvailableYearsForMonthlyPlan() async {
    final response =
        await physicalActivatyViewRepo.getAvailableYearsForMonthlyPlan(
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (data) {
        emit(
          state.copyWith(
            monthlyPlanYearsFilter: data,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(),
        );
      },
    );
  }

  Future<void> getAvailableDateRangesForWeeklyPlan(String selectedYear) async {
    final response =
        await physicalActivatyViewRepo.getAvailableDateRangesForWeeklyPlan(
      language: AppStrings.arabicLang,
      year: selectedYear,
    );
    response.when(
      success: (data) {
        emit(
          state.copyWith(
            weeklyPlanDateRangesFilter: data,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(),
        );
      },
    );
  }

  Future<void> getAvailableDateRangesForMonthlyPlan(String selectedYear) async {
    final response =
        await physicalActivatyViewRepo.getAvailableDateRangesForMonthlyPlan(
      language: AppStrings.arabicLang,
      year: selectedYear,
    );
    response.when(
      success: (data) {
        emit(
          state.copyWith(
            monthlyPlanDateRangesFilter: data,
          ),
        );
      },
      failure: (error) {},
    );
  }

  Future<void> getIntialRequests() async {
    await Future.wait([
      getNutrationDocuments(),
      getAvailableYearsForWeeklyPlan(),
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

    final response = await physicalActivatyViewRepo.getNutrationDocuments(
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

  Future<void> getFilterdNutritionDocuments(
      {required String year, required String rangeDate}) async {
    final currentPlanType = _getPlanTypeNameRelativeToCurrentActiveTab();
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response =
        await physicalActivatyViewRepo.getFilterdNutritionDocuments(
      language: AppStrings.arabicLang,
      planType: currentPlanType,
      year: year,
      rangeDate: rangeDate,
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
            // responseMessage: error.errors.first,
          ),
        );
      },
    );
  }
}
