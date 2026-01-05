import 'package:bloc/bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/supplements/data/models/daily_supplement_submission_model.dart';
import 'package:we_care/features/supplements/data/models/supplement_entry_model.dart';
import 'package:we_care/features/supplements/data/repos/supplements_data_entry_repo.dart';
import 'package:we_care/features/supplements/supplements_data_entry/logic/supplements_data_entry_state.dart';

class SupplementsDataEntryCubit extends Cubit<SupplementsDataEntryState> {
  SupplementsDataEntryCubit(this._supplementsDataEntryRepo)
      : super(SupplementsDataEntryState.initial());
  final SupplementsDataEntryRepo _supplementsDataEntryRepo;

  Future<void> fetchAvailableVitamins() async {
    emit(state.copyWith(vitaminsStatus: RequestStatus.loading));
    final result = await _supplementsDataEntryRepo.retrieveAvailableVitamins(
      language: AppStrings.arabicLang,
    );
    result.when(
      success: (data) {
        emit(
          state.copyWith(
            vitaminsStatus: RequestStatus.success,
            availableVitamins: data,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            vitaminsStatus: RequestStatus.failure,
            message: failure.errors.first,
          ),
        );
      },
    );
  }

  Future<void> getTrackedSupplementsAndVitamins() async {
    emit(
      state.copyWith(
        trackedSupplementsAndVitaminsStatus: RequestStatus.loading,
      ),
    );
    final result =
        await _supplementsDataEntryRepo.getTrackedSupplementsAndVitamins(
      language: AppStrings.arabicLang,
    );
    result.when(
      success: (data) {
        emit(
          state.copyWith(
            trackedSupplementsAndVitaminsStatus: RequestStatus.success,
            trackedSupplementsAndVitamins: data,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            trackedSupplementsAndVitaminsStatus: RequestStatus.failure,
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
      state.copyWith(requestStatus: RequestStatus.loading),
    );
    final result = await _supplementsDataEntryRepo.getAllCreatedPlans(
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
              requestStatus: RequestStatus.success,
            ),
          );
        } else {
          emit(
            state.copyWith(
              monthlyActivationStatus: response.planStatus,
              days: days,
              requestStatus: RequestStatus.success,
            ),
          );
        }

        // call endpoint that returies the list of days
      },
      failure: (failure) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.failure,
            message: failure.errors.first,
            days: [],
          ),
        );
      },
    );
  }

  // New method to update the current tab index
  Future<void> updateCurrentTab(int index) async {
    emit(state.copyWith(supplementFollowUpCurrentTabIndex: index));
    await getPlanActivationStatus();

    //! Load existing plans without toggling
    await loadExistingPlans();
    // refetch data of the list of days
    resetSelectedPlanDate();
  }

  void resetSelectedPlanDate() {
    emit(state.copyWith(selectedPlanDate: ''));
  }

  // Separate method to just load/fetch existing plans without toggling
  Future<void> loadExistingPlans() async {
    final planType = _getPlanTypeNameRelativeToCurrentActiveTab();
    final bool currentPlanActivationStatus = planType == PlanType.weekly.name
        ? state.weeklyActivationStatus
        : state.monthlyActivationStatus;

    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final result = await _supplementsDataEntryRepo.getAllCreatedPlans(
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
              requestStatus: RequestStatus.success,
            ),
          );
        } else {
          emit(
            state.copyWith(
              monthlyActivationStatus: response.planStatus,
              days: days,
              requestStatus: RequestStatus.success,
            ),
          );
        }

        AppLogger.debug(
            'Plans loaded successfully: ${days.length} days, status: ${response.planStatus}');
      },
      failure: (failure) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.failure,
            message: failure.errors.first,
            days: [],
          ),
        );

        AppLogger.error('Failed to load plans: ${failure.errors.first}');
      },
    );
  }

  // navigate to first or second tab , according to activation
  Future<bool?> getAnyActivePlanStatus() async {
    final result = await _supplementsDataEntryRepo.getAnyActivePlanStatus();

    bool? finalResult;

    result.when(
      success: (response) {
        emit(
          state.copyWith(
            isAnyPlanActivated: response.$1,
            supplementFollowUpCurrentTabIndex: response.$2,
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

  String _getPlanTypeNameRelativeToCurrentActiveTab() {
    return state.supplementFollowUpCurrentTabIndex == 0
        ? PlanType.weekly.name
        : PlanType.monthly.name;
  }

  Future<void> getPlanActivationStatus() async {
    final planType = _getPlanTypeNameRelativeToCurrentActiveTab();

    final result = await _supplementsDataEntryRepo.getPlanActivationStatus(
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

  /// this method is used to emit state only if cubit is not closed
  void safeEmit(SupplementsDataEntryState newState) {
    if (!isClosed) emit(newState);
  }

  void updateSupplementName(int index, String name) {
    if (index < 0 || index >= state.entries.length) return;
    final updatedEntries = List<SupplementEntry>.from(state.entries);
    updatedEntries[index] = updatedEntries[index].copyWith(name: name);
    emit(state.copyWith(entries: updatedEntries));
  }

  void updateDosage(int index, int dosage) {
    if (index < 0 || index >= state.entries.length) return;
    final updatedEntries = List<SupplementEntry>.from(state.entries);
    updatedEntries[index] =
        updatedEntries[index].copyWith(dosagePerDay: dosage);
    emit(state.copyWith(entries: updatedEntries));
  }

  List<SupplementEntry> buildSupplementsPayload() {
    return state.entries
        .where((e) => e.name != null && e.dosagePerDay > 0)
        .toList();
  }

  Future<void> submitSupplements() async {
    final supplements = buildSupplementsPayload();
    if (supplements.isEmpty) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.failure,
          message: "يرجى اختيار مكمل واحد على الأقل",
        ),
      );
      return;
    }

    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _supplementsDataEntryRepo.submitSelectedSupplements(
      supplements: supplements,
    );

    result.when(
      success: (message) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            message: message,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.failure,
            message: failure.errors.first,
          ),
        );
      },
    );
  }

  Future<void> submitDailyUserTakenSupplement({
    required DailySupplementSubmissionModel dailyTakenSupplements,
  }) async {
    safeEmit(
        state.copyWith(submitDailySupplementStatus: RequestStatus.loading));

    final result =
        await _supplementsDataEntryRepo.submitDailyUserTakenSupplement(
      submission: dailyTakenSupplements,
    );

    result.when(
      success: (message) {
        safeEmit(
          state.copyWith(
            submitDailySupplementStatus: RequestStatus.success,
            message: message,
          ),
        );
      },
      failure: (failure) {
        safeEmit(
          state.copyWith(
            submitDailySupplementStatus: RequestStatus.failure,
            message: failure.errors.first,
          ),
        );
      },
    );
  }

  Future<void> deleteSubmittedSupplementOnSpecificDate(String date) async {
    final result =
        await _supplementsDataEntryRepo.deleteSubmittedSupplementOnSpecificDate(
      date: date,
    );
    result.when(
      success: (response) async {
        safeEmit(
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

  Future<void> getSupplementTableData({required String date}) async {
    safeEmit(state.copyWith(supplementTableStatus: RequestStatus.loading));
    final result = await _supplementsDataEntryRepo.retrieveDailyFollowUpTable(
      date: date,
      language: AppStrings.arabicLang,
    );
    result.when(
      success: (rows) {
        safeEmit(
          state.copyWith(
            supplementTableStatus: RequestStatus.success,
            supplementTableRows: rows,
          ),
        );
      },
      failure: (failure) {
        safeEmit(
          state.copyWith(
            supplementTableStatus: RequestStatus.failure,
            message: failure.errors.first,
          ),
        );
      },
    );
  }
}
