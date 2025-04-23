import 'package:bloc/bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/medicine/data/models/get_all_user_medicines_responce_model.dart';
import 'package:we_care/features/medicine/data/repos/medicine_view_repo.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_state.dart';

class MedicineViewCubit extends Cubit<MedicineViewState> {
  MedicineViewCubit(this._medicinesViewRepo)
      : super(MedicineViewState.initial());
  final MedicinesViewRepo _medicinesViewRepo;

  List<MedicineModel> getMedicinesByDate(String targetDate) {
  return state.userMedicines.where((medicine) {
    final medicineDate = medicine.startDate;
    return medicineDate==targetDate; 
  }).toList();
}
  Future<void> getMedicinesFilters() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _medicinesViewRepo.getMedicinesFilters(
        language: AppStrings.arabicLang, userType: 'Patient');

    result.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        yearsFilter: response.years,
        medicineNameFilter: response.medicinesNames,
      ));
    }, failure: (error) {
      emit(state.copyWith(requestStatus: RequestStatus.failure));
    });
  }

  Future<void> getUserMedicinesList() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _medicinesViewRepo.getAllMedicines(
        language: AppStrings.arabicLang, userType: 'Patient');
    result.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        userMedicines: response.medicineList,
        responseMessage: response.message,
      ));
    }, failure: (error) {
      emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          responseMessage: error.errors.first));
    });
  }

  Future<void> getMedicineDetailsById(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _medicinesViewRepo.getMedicineById(
        id: id, language: AppStrings.arabicLang, userType: 'Patient');

    result.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        selectedSurgeryDetails: response,
      ));
    }, failure: (error) {
      emit(state.copyWith(requestStatus: RequestStatus.failure));
    });
  }

  Future<void> deleteMedicineById(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _medicinesViewRepo.deleteMedicineById(
      id: id,
      language: AppStrings.arabicLang,
      userType: 'Patient',
    );

    result.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        responseMessage: response,
        isDeleteRequest: true,
      ));
    }, failure: (error) {
      emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          responseMessage: error.errors.first,
          isDeleteRequest: true));
    });
  }

  //get filtered medicines
  Future<void> getFilteredMedicinesList(
      {required final int? year, required final String? medicineName}) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _medicinesViewRepo.getFilteredMedicines(
        language: AppStrings.arabicLang,
        userType: 'Patient',
        year: year,
        medicineName: medicineName);
    result.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        userMedicines: response.medicineList,
        responseMessage: response.message,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
        responseMessage: error.errors.first,
      ));
    });
  }
}
