import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/nutration/data/models/get_all_created_plans_model.dart';
import 'package:we_care/features/physical_activaty/data/models/post_personal_nutrition_data_model.dart';
import 'package:we_care/features/physical_activaty/data/models/workout_activity_model.dart';
import 'package:we_care/features/physical_activaty/data/repos/physical_activaty_data_entry_repo.dart';

part 'physical_activaty_data_entry_state.dart';

class PhysicalActivatyDataEntryCubit
    extends Cubit<PhysicalActivatyDataEntryState> {
  PhysicalActivatyDataEntryCubit(this._physicalActivatyDataEntryRepo)
      : super(
          PhysicalActivatyDataEntryState.initialState(),
        );
  final TextEditingController weightController = TextEditingController();

  final TextEditingController heightController = TextEditingController();

  final TextEditingController ageController = TextEditingController();

  final PhysicalActivatyDataEntryRepo _physicalActivatyDataEntryRepo;

  // New method to update the current tab index
  Future<void> updateCurrentTab(int index) async {
    emit(state.copyWith(followUpNutrationViewCurrentTabIndex: index));
    // await getPlanActivationStatus();

    //! Load existing plans without toggling
    // await loadExistingPlans();
    // refetch data of the list of days
    resetSelectedPlanDate();
  }

  void updateSelectedPlanDate(String date) {
    emit(state.copyWith(selectedPlanDate: date));
  }

  void updateGenderType(String type) {
    emit(state.copyWith(genderType: type));
  }

  void updateSelectedMuscleDesity(String val) {
    emit(state.copyWith(selectedMuscleDesity: val));
  }

  void resetSelectedPlanDate() {
    emit(state.copyWith(selectedPlanDate: ''));
  }

  Future<void> postPersonalUserInfoData() async {
    emit(state.copyWith(
        submitPhysicalActivityDataStatus: RequestStatus.loading));

    final result =
        await _physicalActivatyDataEntryRepo.postPersonalUserInfoData(
      requestBody: PostPersonalUserInfoData(
        weight: int.parse(weightController.text),
        height: int.parse(heightController.text),
        age: int.parse(ageController.text),
        gender: state.genderType!,
        physicalActivity: state.selectedMuscleDesity!,
      ),
      lanugage: AppStrings.arabicLang,
    );
    result.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            submitPhysicalActivityDataStatus: RequestStatus.success,
            message: successMessage,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            submitPhysicalActivityDataStatus: RequestStatus.failure,
            message: failure.errors.first,
          ),
        );
      },
    );
  }

  // each change in tab will call this method
  Future<void> togglePlanActivationAndLoadingExistingPlans() async {
    final planType = _getPlanTypeNameRelativeToCurrentActiveTab();
    final bool currentPlanActivationStatus = planType == PlanType.weekly.name
        ? state.weeklyActivationStatus
        : state.monthlyActivationStatus;
    emit(
      state.copyWith(submitPhysicalActivityDataStatus: RequestStatus.loading),
    );
    final result = await _physicalActivatyDataEntryRepo.getAllCreatedPlans(
      lanugage: AppStrings.arabicLang,
      planActivationStatus:
          !currentPlanActivationStatus, //! toggle it before call get plan again
      planType: planType,
    );

    result.when(
      success: (response) {
        final days = response.plan.days;
        if (planType == PlanType.weekly.name) {
          emit(
            state.copyWith(
              weeklyActivationStatus: response.planStatus,
              days: days,
              submitPhysicalActivityDataStatus: RequestStatus.success,
            ),
          );
        } else {
          emit(
            state.copyWith(
              monthlyActivationStatus: response.planStatus,
              days: days,
              submitPhysicalActivityDataStatus: RequestStatus.success,
            ),
          );
        }

        // call endpoint that returies the list of days
      },
      failure: (failure) {
        emit(
          state.copyWith(
            submitPhysicalActivityDataStatus: RequestStatus.failure,
            message: failure.errors.first,
            days: [],
          ),
        );
      },
    );
  }

  // Separate method to just load/fetch existing plans without toggling
  Future<void> loadExistingPlans() async {
    final planType = _getPlanTypeNameRelativeToCurrentActiveTab();
    final bool currentPlanActivationStatus = planType == PlanType.weekly.name
        ? state.weeklyActivationStatus
        : state.monthlyActivationStatus;

    emit(state.copyWith(
        submitPhysicalActivityDataStatus: RequestStatus.loading));

    final result = await _physicalActivatyDataEntryRepo.getAllCreatedPlans(
      lanugage: AppStrings.arabicLang,
      planActivationStatus: currentPlanActivationStatus,
      planType: planType,
    );

    result.when(
      success: (response) {
        final days = response.plan.days;

        if (planType == PlanType.weekly.name) {
          emit(
            state.copyWith(
              weeklyActivationStatus: response.planStatus,
              days: days,
              submitPhysicalActivityDataStatus: RequestStatus.success,
            ),
          );
        } else {
          emit(
            state.copyWith(
              monthlyActivationStatus: response.planStatus,
              days: days,
              submitPhysicalActivityDataStatus: RequestStatus.success,
            ),
          );
        }

        AppLogger.debug(
            'Plans loaded successfully: ${days.length} days, status: ${response.planStatus}');
      },
      failure: (failure) {
        emit(
          state.copyWith(
            submitPhysicalActivityDataStatus: RequestStatus.failure,
            message: failure.errors.first,
            days: [],
          ),
        );

        AppLogger.error('Failed to load plans: ${failure.errors.first}');
      },
    );
  }

  Future<void> getPlanActivationStatus() async {
    final planType = _getPlanTypeNameRelativeToCurrentActiveTab();

    final result = await _physicalActivatyDataEntryRepo.getPlanActivationStatus(
      language: AppStrings.arabicLang,
      planType: planType,
    );

    result.when(
      success: (status) {
        if (planType == PlanType.weekly.name) {
          emit(
            state.copyWith(
              weeklyActivationStatus: status,
            ),
          );
          AppLogger.debug("ana ray7 afta7l plan activation status weekly");
          status ? loadExistingPlans() : null;
        } else {
          emit(
            state.copyWith(
              monthlyActivationStatus: status,
            ),
          );
          AppLogger.debug("ana ray7 afta7l plan activation status Monthly");
        }
        AppLogger.debug(
            ' getPlanActivationStatus called and => Plan activation status for $planType: $status');
      },
      failure: (failure) {
        AppLogger.error(
            'Error in getPlanActivationStatus: ${failure.errors.first}');
        safeEmit(
          state.copyWith(
            message: failure.errors.first,
          ),
        );
      },
    );
  }

  Future<bool?> getAnyActivePlanStatus() async {
    final result =
        await _physicalActivatyDataEntryRepo.getAnyActivePlanStatus();

    bool? finalResult;

    result.when(
      success: (response) {
        emit(
          state.copyWith(
            isAnyPlanActivated: response.$1,
            followUpNutrationViewCurrentTabIndex: response.$2,
          ),
        );
        finalResult = response.$1;
      },
      failure: (failure) {
        AppLogger.error(
            'Error in getAnyActivePlanStatus: ${failure.errors.first}');
        safeEmit(
          state.copyWith(message: failure.errors.first),
        );
        finalResult = null;
      },
    );

    return finalResult;
  }

  Future<void> deleteDayDietPlan(String date) async {
    final result = await _physicalActivatyDataEntryRepo.deleteDayDietPlan(
      date: date,
    );
    result.when(
      success: (response) async {
        emit(
          state.copyWith(
            message: response,
          ),
        );
      },
      failure: (failure) {
        safeEmit(
          state.copyWith(
            message: failure.errors.first,
          ),
        );
      },
    );
  }

  Future<void> postDailyDietPlan(
      List<WorkoutActivity> activities, String date) async {
    emit(state.copyWith(
        submitPhysicalActivityDataStatus: RequestStatus.loading));
    final result = await _physicalActivatyDataEntryRepo.postDailyDietPlan(
      requestBody: activities,
      lanugage: AppStrings.arabicLang,
      date: date,
    );
    result.when(
      success: (response) async {
        safeEmit(
          state.copyWith(
            submitPhysicalActivityDataStatus: RequestStatus.success,
            message: response,
          ),
        );
      },
      failure: (failure) {
        safeEmit(
          state.copyWith(
            submitPhysicalActivityDataStatus: RequestStatus.failure,
            message: failure.errors.first,
          ),
        );
      },
    );
  }

  String _getPlanTypeNameRelativeToCurrentActiveTab() {
    return state.followUpNutrationViewCurrentTabIndex == 0
        ? PlanType.weekly.name
        : PlanType.monthly.name;
  }

  /// this method is used to emit state only if cubit is not closed
  void safeEmit(PhysicalActivatyDataEntryState newState) {
    if (!isClosed) emit(newState);
  }

  @override
  Future<void> close() {
    weightController.dispose();
    heightController.dispose();
    ageController.dispose();
    return super.close();
  }
}
