import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/features/Biometrics/biometrics_data_entry/logic/cubit/biometrics_data_entry_state.dart';
import 'package:we_care/features/Biometrics/data/repos/biometrics_data_entry_repo.dart';

class BiometricsDataEntryCubit extends Cubit<BiometricsDataEntryState> {
  BiometricsDataEntryCubit(this.biometricsDataEntryRepo)
      : super(
          BiometricsDataEntryState.initialState(),
        );

  final BiometricsDataEntryRepo biometricsDataEntryRepo;

  // Future<void> postBiometricsDataEntry({
  //   required String categoryName,
  //   required String value,
  //   required String unit,
  // }) async {
  //   emit(state.copyWith(submitBiometricDataStatus: RequestStatus.loading));
  //   final result = await biometricsDataEntryRepo.postBiometricsDataEntry(
  //     categoryName: categoryName,
  //     value: value,
  //     unit: unit,
  //   );
  //   result.fold(
  //     (failure) => emit(
  //       state.copyWith(
  //         submitBiometricDataStatus: RequestStatus.failure,
  //         message: failure.errors.first,
  //       ),
  //     ),
  //     (successMessage) => emit(
  //       state.copyWith(
  //         submitBiometricDataStatus: RequestStatus.success,
  //         message: successMessage,
  //       ),
  //     ),
  //   );
  // }
}
