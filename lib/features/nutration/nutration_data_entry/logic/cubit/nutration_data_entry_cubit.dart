import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manual_speech_to_text/manual_speech_to_text.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/Biometrics/data/models/post_biometric_data_of_specifc_category_model.dart';
import 'package:we_care/features/nutration/data/repos/nutration_data_entry_repo.dart';

part 'nutration_data_entry_state.dart';

class NutrationDataEntryCubit extends Cubit<NutrationDataEntryState> {
  NutrationDataEntryCubit(this._nutrationDataEntryRepo, this.context)
      : super(
          NutrationDataEntryState.initialState(),
        ) {
    _init();
  }

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

  Future<void> postNutrationDataEntry({
    required String categoryName,
    required String minValue,
    String? maxValue,
  }) async {
    emit(state.copyWith(submitNutrationDataStatus: RequestStatus.loading));

    final result = await _nutrationDataEntryRepo.postNutrationDataEntry(
      requestBody: PostBiometricCategoryModel(
        categoryName: categoryName,
        minValue: minValue,
        maxValue:
            maxValue, //should handle in case there was an max an min value
      ),
      lanugage: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );
    result.when(success: (successMessage) {
      emit(
        state.copyWith(
          submitNutrationDataStatus: RequestStatus.success,
          message: successMessage,
        ),
      );
    }, failure: (failure) {
      emit(
        state.copyWith(
          submitNutrationDataStatus: RequestStatus.failure,
          message: failure.errors.first,
        ),
      );
    });
  }

  @override
  Future<void> close() {
    _speechToTextController.dispose();
    monthlyMessageController.dispose();
    weeklyMessageController.dispose();
    return super.close();
  }
}
