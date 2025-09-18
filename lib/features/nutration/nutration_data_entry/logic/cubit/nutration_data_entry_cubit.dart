import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manual_speech_to_text/manual_speech_to_text.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/nutration/data/models/nutration_facts_data_model.dart';
import 'package:we_care/features/nutration/data/models/post_personal_nutrition_data_model.dart';
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
        log('Speech state: ${state.name}');
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
        log("Recognized text: $recognizedText");
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
      log(e.toString());
      emit(state.copyWith(isListening: false));
    }
  }

  // New method to update the current tab index
  void updateCurrentTab(int index) {
    emit(state.copyWith(followUpNutrationViewCurrentTabIndex: index));
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

    if (dietInput.isEmpty) {
      emit(
        state.copyWith(
          submitNutrationDataStatus: RequestStatus.failure,
          message: 'يرجى إدخال بيانات الطعام أولاً',
        ),
      );
      return;
    }

    try {
      // Start loading
      emit(
        state.copyWith(
          submitNutrationDataStatus: RequestStatus.loading,
          nutrationFactsModel: null,
          message: 'جاري تحليل البيانات الغذائية...',
        ),
      );

      // Call ChatGPT service
      final nutritionData = await DeepSeekService.analyzeDietPlan(dietInput);

      emit(
        state.copyWith(
          submitNutrationDataStatus: RequestStatus.success,
          nutrationFactsModel: nutritionData,
          message: 'تم تحليل البيانات الغذائية بنجاح',
        ),
      );
      clearRelativeControllerToCurrentTab();
      // You can now use nutritionData to send to your backend
      //  await _sendNutritionDataToBackend(nutritionData);
    } catch (e) {
      log('Error in analyzeDietPlan: $e');
      emit(
        state.copyWith(
          submitNutrationDataStatus: RequestStatus.failure,
          message: 'حدث خطأ أثناء تحليل البيانات الغذائية',
        ),
      );
    }
  }

  clearRelativeControllerToCurrentTab() {
    if (state.followUpNutrationViewCurrentTabIndex == 0) {
      weeklyMessageController.clear();
    } else {
      monthlyMessageController.clear();
    }
    emit(state.copyWith(recognizedText: ''));
  }

  // Optional: Method to send nutrition data to your backend
  Future<void> _sendNutritionDataToBackend(
      NutrationFactsModel nutritionData) async {
    // Implement your backend API call here
    // This is where you would send the analyzed nutrition data to your server
    log('Sending nutrition data to backend: ${nutritionData.toJson()}');
  }

  Future<void> postPersonalNutritionData() async {
    emit(state.copyWith(submitNutrationDataStatus: RequestStatus.loading));

    final result = await _nutrationDataEntryRepo.postPersonalNutritionData(
      requestBody: PostPersonalNutritionData(
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
        log('Error in getAllChronicDiseases: ${failure.errors.first}');
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
