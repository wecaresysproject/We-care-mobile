import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/features/Biometrics/biometrics_data_entry/logic/cubit/biometrics_data_entry_state.dart';
import 'package:we_care/features/Biometrics/data/repos/biometrics_data_entry_repo.dart';

class BiometricsDataEntryCubit extends Cubit<BiometricsDataEntryState> {
  BiometricsDataEntryCubit(BiometricsDataEntryRepo biometricsDataEntryRepo)
      : super(
          BiometricsDataEntryState.initialState(),
        );

  Future<void> initialDataEntryRequests() async {}

  // Future<void> updateSelectedDoseDuration(String? doseDuration) async {
  //   emit(state.copyWith(doseDuration: doseDuration));
  //   await emitAllDurationsForCategory();
  //   validateRequiredFields();
  // }
}
