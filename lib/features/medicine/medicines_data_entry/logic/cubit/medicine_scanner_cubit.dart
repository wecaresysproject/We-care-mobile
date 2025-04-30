import 'package:bloc/bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/medicine/data/repos/medicine_data_entry_repo.dart' show MedicinesDataEntryRepo;
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicine_scanner_state';


class MedicineScannerCubit extends Cubit<MedicineScannerState> {
  final MedicinesDataEntryRepo _medicinesDataEntryRepo;

  MedicineScannerCubit(this._medicinesDataEntryRepo)
      : super(MedicineScannerState.initialState());

  Future<void> getMatchedMedicines({required String query}) async {
    emit(
      state.copyWith(
        medicinesScannerStatus: RequestStatus.loading,
      ),
    );
    if (query.isEmpty) {
      query = 'A';
    }
    final response = await _medicinesDataEntryRepo.getMatchedMedicines(
      language: AppStrings.arabicLang,
      userType: 'Patient',
      medicineName: query,
    );
    response.when(
      success: (medicines) {
        emit(
          state.copyWith(
            matchedMedicines: medicines,
            medicinesScannerStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            medicinesScannerStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }
}