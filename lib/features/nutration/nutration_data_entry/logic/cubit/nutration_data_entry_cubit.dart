import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manual_speech_to_text/manual_speech_to_text.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/nutration/data/models/get_all_created_plans_model.dart';
import 'package:we_care/features/nutration/data/models/nutration_element_table_row_model.dart';
import 'package:we_care/features/nutration/data/models/nutration_facts_data_model.dart';
import 'package:we_care/features/nutration/data/models/post_personal_nutrition_data_model.dart';
import 'package:we_care/features/nutration/data/models/update_nutrition_value_model.dart';
import 'package:we_care/features/nutration/data/repos/nutration_data_entry_repo.dart';
import 'package:we_care/features/nutration/nutration_data_entry/logic/deep_seek_services.dart';

part 'nutration_data_entry_state.dart';

class NutrationDataEntryCubit extends Cubit<NutrationDataEntryState> {
  NutrationDataEntryCubit(this._nutrationDataEntryRepo, this.context)
      : super(
          NutrationDataEntryState.initialState(),
        ) {
    _init();
  }
  final TextEditingController weightController = TextEditingController();

  final TextEditingController heightController = TextEditingController();

  final TextEditingController ageController = TextEditingController();
  // A private async method to handle all asynchronous setup
  Future<void> _init() async {
    _speechToTextController = ManualSttController(context);
    _setupSpeechController();
  }

  final NutrationDataEntryRepo _nutrationDataEntryRepo;
  final BuildContext context; // New addition
  // Controllers for each tab
  final TextEditingController weeklyMessageController = TextEditingController();
  final TextEditingController monthlyMessageController =
      TextEditingController();

  late ManualSttController _speechToTextController; // Changed from SpeechToText

  // Initialize Speech-to-Text
  void _setupSpeechController() {
    _speechToTextController.listen(
      onListeningStateChanged: (state) {
        if (state == ManualSttState.listening) {
          emit(this.state.copyWith(isListening: true));
        } else {
          emit(this.state.copyWith(isListening: false));
        }
        AppLogger.debug('Speech state: ${state.name}');
      },
      onListeningTextChanged: (recognizedText) {
        emit(
          state.copyWith(
            recognizedText: recognizedText,
          ),
        );
        // Update the correct controller based on the current tab index
        if (state.followUpNutrationViewCurrentTabIndex == 0) {
          weeklyMessageController.text = recognizedText;
        } else {
          monthlyMessageController.text = recognizedText;
        }
        AppLogger.debug("Recognized text: $recognizedText");
      },
    );

    // Optional: You can set other properties here
    _speechToTextController.clearTextOnStart = true;
    _speechToTextController.pauseIfMuteFor = Duration(seconds: 10);
    _speechToTextController.localId = 'ar_EG';
    // _speechToTextController.enableHapticFeedback = true;
  }

  // Start listening for speech
  void startListening() {
    try {
      emit(
        state.copyWith(
          isListening: true,
          recognizedText: '',
        ),
      );
      // Use the new controller's start method
      _speechToTextController.startStt();
    } catch (e) {
      AppLogger.error(e.toString());
      emit(state.copyWith(isListening: false));
    }
  }

  // New method to update the current tab index
  Future<void> updateCurrentTab(int index) async {
    emit(state.copyWith(followUpNutrationViewCurrentTabIndex: index));
    await getPlanActivationStatus();

    //! Load existing plans without toggling
    await loadExistingPlans();
    // refetch data of the list of days
    resetSelectedPlanDate();
  }

  void updateSelectedPlanDate(String date) {
    emit(state.copyWith(selectedPlanDate: date));
  }

  void updateGenderType(String type) {
    emit(state.copyWith(genderType: type));
  }

  void updateSelectedPhysicalActivity(String physicalActivity) {
    emit(state.copyWith(selectedPhysicalActivity: physicalActivity));
  }

  void updateSelectedChronicDiseases(String? value) {
    if (value == null || value.isEmpty) return;

    List<String> chronicDiseases = List.from(state.selectedChronicDiseases);

    // Toggle selection - if already selected, remove it; otherwise add it
    if (chronicDiseases.contains(value)) {
      chronicDiseases.remove(value);
    } else {
      chronicDiseases.add(value);
    }

    emit(state.copyWith(selectedChronicDiseases: chronicDiseases));
  }

  void removeChronicDisease(String cause) {
    List<String> chronicDiseases = List.from(state.selectedChronicDiseases);
    chronicDiseases.remove(cause);
    emit(state.copyWith(selectedChronicDiseases: chronicDiseases));
  }

  void resetSelectedPlanDate() {
    emit(state.copyWith(selectedPlanDate: ''));
  }

  // Stop listening for speech
  void stopListening() {
    if (state.isListening) {
      try {
        emit(
          state.copyWith(
            isListening: false,
          ),
        );
        _speechToTextController.stopStt();

        // The listener will update the state
      } catch (e) {
        emit(
          state.copyWith(
            isListening: false,
          ),
        );
      }
    }
  }

  // Toggle listening (start/stop)
  void toggleListening() {
    if (state.isListening) {
      stopListening();
    } else {
      startListening();
    }
  }

  // NEW METHOD: Analyze diet plan using ChatGPT
  Future<void> analyzeDietPlan() async {
    // Get the current diet input based on active tab
    String dietInput;
    if (state.followUpNutrationViewCurrentTabIndex == 0) {
      dietInput = weeklyMessageController.text.trim();
    } else {
      dietInput = monthlyMessageController.text.trim();
    }

    if (dietInput.isEmpty || state.selectedPlanDate.isEmpty) {
      emit(
        state.copyWith(
          submitNutrationDataStatus: RequestStatus.failure,
          message: 'يرجى إدخال بيانات الطعام واختيار اليوم معا اولا',
        ),
      );
      return;
    }

    try {
      // Start loading
      emit(
        state.copyWith(
          submitNutrationDataStatus: RequestStatus.loading,
        ),
      );

      // Call ChatGPT service
      final nutritionData = await DeepSeekService.analyzeDietPlan(dietInput);

      // You can now use nutritionData to send to your backend
      await postDailyDietPlan(
        nutritionData: nutritionData!,
        userDietplan: dietInput,
      );
    } catch (e) {
      AppLogger.error('Error in analyzeDietPlan: $e');
      emit(
        state.copyWith(
          submitNutrationDataStatus: RequestStatus.failure,
          message: 'حدث خطأ أثناء تحليل البيانات الغذائية',
        ),
      );
    }
  }

  void clearRelativeControllerToCurrentTab() {
    if (state.followUpNutrationViewCurrentTabIndex == 0) {
      weeklyMessageController.clear();
    } else {
      monthlyMessageController.clear();
    }
    emit(state.copyWith(recognizedText: ''));
  }

  // Optional: Method to send nutrition data to your backend
  Future<void> postDailyDietPlan({
    required NutrationFactsModel nutritionData,
    required String userDietplan,
  }) async {
    final result = await _nutrationDataEntryRepo.postDailyDietPlan(
      requestBody: nutritionData,
      lanugage: AppStrings.arabicLang,
      date: state.selectedPlanDate,
    );
    result.when(
      success: (successMessage) async {
        emit(
          state.copyWith(
            submitNutrationDataStatus: RequestStatus.success,
            message: successMessage,
            isFoodAnalysisSuccess: true,
          ),
        );
        clearRelativeControllerToCurrentTab();
        await loadExistingPlans();
        AppLogger.debug(
          'successMessage for  postDailyDietPlan: $successMessage'
          'submitNutrationDataStatus: ${state.submitNutrationDataStatus}',
        );
        // call endpoint that returies the list of days
      },
      failure: (failure) {
        emit(
          state.copyWith(
            submitNutrationDataStatus: RequestStatus.failure,
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
      state.copyWith(submitNutrationDataStatus: RequestStatus.loading),
    );
    final result = await _nutrationDataEntryRepo.getAllCreatedPlans(
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
              submitNutrationDataStatus: RequestStatus.success,
            ),
          );
        } else {
          emit(
            state.copyWith(
              monthlyActivationStatus: response.planStatus,
              days: days,
              submitNutrationDataStatus: RequestStatus.success,
            ),
          );
        }

        clearRelativeControllerToCurrentTab();

        // call endpoint that returies the list of days
      },
      failure: (failure) {
        emit(
          state.copyWith(
            submitNutrationDataStatus: RequestStatus.failure,
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

    emit(state.copyWith(submitNutrationDataStatus: RequestStatus.loading));

    final result = await _nutrationDataEntryRepo.getAllCreatedPlans(
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
              submitNutrationDataStatus: RequestStatus.success,
            ),
          );
        } else {
          emit(
            state.copyWith(
              monthlyActivationStatus: response.planStatus,
              days: days,
              submitNutrationDataStatus: RequestStatus.success,
            ),
          );
        }

        AppLogger.debug(
            'Plans loaded successfully: ${days.length} days, status: ${response.planStatus}');
      },
      failure: (failure) {
        emit(
          state.copyWith(
            submitNutrationDataStatus: RequestStatus.failure,
            message: failure.errors.first,
            days: [],
          ),
        );

        AppLogger.error('Failed to load plans: ${failure.errors.first}');
      },
    );
  }

  Future<void> postPersonalUserInfoData() async {
    emit(state.copyWith(submitNutrationDataStatus: RequestStatus.loading));

    final result = await _nutrationDataEntryRepo.postPersonalUserInfoData(
      requestBody: PostPersonalUserInfoData(
        weight: int.parse(weightController.text),
        height: int.parse(heightController.text),
        age: int.parse(ageController.text),
        gender: state.genderType!,
        physicalActivity: state.selectedPhysicalActivity!,
        chronicDisease: state.selectedChronicDiseases,
      ),
      lanugage: AppStrings.arabicLang,
    );
    result.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            submitNutrationDataStatus: RequestStatus.success,
            message: successMessage,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            submitNutrationDataStatus: RequestStatus.failure,
            message: failure.errors.first,
          ),
        );
      },
    );
  }

  Future<void> getAllNutrationTableData({required String date}) async {
    emit(state.copyWith(dataTableStatus: RequestStatus.loading));

    final result = await _nutrationDataEntryRepo.getAllNutrationTableData(
      language: AppStrings.arabicLang,
      date: date,
    );
    result.when(
      success: (response) {
        emit(
          state.copyWith(
            nutrationElementsRows: response,
            dataTableStatus: RequestStatus.success,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            dataTableStatus: RequestStatus.failure,
            message: failure.errors.first,
          ),
        );
      },
    );
  }

  Future<void> getAllChronicDiseases() async {
    final result = await _nutrationDataEntryRepo.getAllChronicDiseases(
      language: AppStrings.arabicLang,
    );
    result.when(
      success: (diseases) {
        emit(
          state.copyWith(
            chronicDiseases: diseases,
          ),
        );
      },
      failure: (failure) {
        AppLogger.error(
            'Error in getAllChronicDiseases: ${failure.errors.first}');
        safeEmit(
          state.copyWith(
            message: failure.errors.first,
          ),
        );
      },
    );
  }

  Future<bool?> getAnyActivePlanStatus() async {
    final result = await _nutrationDataEntryRepo.getAnyActivePlanStatus();

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
    final result = await _nutrationDataEntryRepo.deleteDayDietPlan(
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

  Future<void> updateNutrientStandard({
    required String standardNutrientName,
    required double newStandard,
    required String date,
  }) async {
    final result = await _nutrationDataEntryRepo.updateNutrientStandard(
      language: AppStrings.arabicLang,
      requestBody: UpdateNutritionValueModel(
        newStandard: newStandard,
      ),
      nutrientName: standardNutrientName,
    );
    AppLogger.debug(" updateNutrientStandard : $standardNutrientName , $date");
    result.when(
      success: (successMessage) async {
        await getAllNutrationTableData(date: date);
        emit(
          state.copyWith(
            message: successMessage,
            isEditMode: true,
          ),
        );
      },
      failure: (failure) {
        AppLogger.error(
            'Error in updateNutrientStandard: ${failure.errors.first}');
        safeEmit(
          state.copyWith(
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

  Future<void> getPlanActivationStatus() async {
    final planType = _getPlanTypeNameRelativeToCurrentActiveTab();

    final result = await _nutrationDataEntryRepo.getPlanActivationStatus(
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
  void safeEmit(NutrationDataEntryState newState) {
    if (!isClosed) emit(newState);
  }

  @override
  Future<void> close() {
    _speechToTextController.dispose();
    monthlyMessageController.dispose();
    weeklyMessageController.dispose();
    weightController.dispose();
    heightController.dispose();
    ageController.dispose();
    return super.close();
  }
}
