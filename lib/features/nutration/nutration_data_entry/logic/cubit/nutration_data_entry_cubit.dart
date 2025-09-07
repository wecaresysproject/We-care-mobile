import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/Biometrics/data/models/post_biometric_data_of_specifc_category_model.dart';
import 'package:we_care/features/nutration/data/repos/nutration_data_entry_repo.dart';

part 'nutration_data_entry_state.dart';

class NutrationDataEntryCubit extends Cubit<NutrationDataEntryState> {
  NutrationDataEntryCubit(this._nutrationDataEntryRepo)
      : super(
          NutrationDataEntryState.initialState(),
        ) {
    _initSpeech();
  }

  final NutrationDataEntryRepo _nutrationDataEntryRepo;
  // Controllers for each tab
  final TextEditingController weeklyMessageController = TextEditingController();
  late SpeechToText _speechToText;

  // Initialize Speech-to-Text
  Future<void> _initSpeech() async {
    try {
      _speechToText = SpeechToText();
      bool isAvailable = await _speechToText.initialize();

      // if (isAvailable) {
      //   emit(
      //     state.copyWith(
      //       isListening: true,
      //     ),
      //   );
      // } else {
      //   emit(
      //     state.copyWith(
      //       isListening: false,
      //     ),
      //   );
      // }
    } catch (e) {
      log(e.toString());
    }
  }

  // Start listening for speech
  Future<void> startListening() async {
    try {
      emit(
        state.copyWith(
          isListening: true,
          recognizedText: '',
        ),
      );

      await _speechToText.listen(
        listenOptions: SpeechListenOptions(
          // partialResults: true,
          listenMode: ListenMode.confirmation,
          cancelOnError: true,
          // onDevice: true,
        ),
        onResult: (result) {
          emit(
            state.copyWith(
              recognizedText: result.recognizedWords,
              isListening: true,
            ),
          );
          weeklyMessageController.text = result.recognizedWords;
          log("Recognized text: ${result.recognizedWords}");
        },

        localeId: "ar_EG", // Arabic Egypt locale
        listenFor: const Duration(minutes: 2), // Listen for 2 minutes
        pauseFor: const Duration(
          seconds: 2,
        ), // Pause after 2 seconds of silence
      );
    } catch (e) {
      log(e.toString());
    }
  }

  // Stop listening for speech
  Future<void> stopListening() async {
    if (state.isListening) {
      try {
        await _speechToText.stop();
        emit(
          state.copyWith(
            isListening: false,
          ),
        );
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
  Future<void> toggleListening() async {
    if (state.isListening) {
      await stopListening();
    } else {
      await startListening();
    }
  }

  // Clear recognized text
  void clearRecognizedText() {
    emit(state.copyWith(
      recognizedText: '',
    ));
    weeklyMessageController.clear();
  }

  // Update recognized text manually (for testing or manual input)
  void updateRecognizedText(String text) {
    emit(state.copyWith(recognizedText: text));
    weeklyMessageController.text = text;
  }

  // Apply recognized text to text controller
  void applyRecognizedTextToController(TextEditingController controller) {
    final currentText = controller.text;
    final recognizedText = state.recognizedText;

    if (recognizedText.isNotEmpty) {
      // Append recognized text to existing text with a space
      final newText =
          currentText.isEmpty ? recognizedText : '$currentText $recognizedText';

      controller.text = newText;

      // Move cursor to the end
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );

      // Clear recognized text after applying
      clearRecognizedText();
    }
  }
  // Reset all states
  // void resetStates() {
  //   emit(state.copyWith(
  //     submitNutrationDataStatus: RequestStatus.idle,
  //     speechStatus: RequestStatus.idle,
  //     isListening: false,
  //     recognizedText: '',
  //     message: '',
  //   ));
  // }

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
    // TODO: implement close
    weeklyMessageController.dispose();

    return super.close();
  }
}
