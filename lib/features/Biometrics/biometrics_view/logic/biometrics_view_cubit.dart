import 'dart:developer';

import 'package:alarm/alarm.dart';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/medicine/data/models/get_all_user_medicines_responce_model.dart';
import 'package:we_care/features/medicine/data/models/medicine_alarm_model.dart';
import 'package:we_care/features/medicine/data/repos/medicine_view_repo.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_state.dart';
import 'package:we_care/features/medicine/medicines_api_constants.dart';

class MedicineViewCubit extends Cubit<MedicineViewState> {
  MedicineViewCubit(this._medicinesViewRepo)
      : super(MedicineViewState.initial());
  final MedicinesViewRepo _medicinesViewRepo;
  int currentPage = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool isLoadingMore = false;

  Future<void> init() async {
    await getMedicinesFilters();
    await getUserMedicinesList(page: 1, pageSize: 10);
  }

  List<MedicineModel> getMedicinesByDate(String targetDate) {
    return state.userMedicines.where((medicine) {
      final medicineDate = medicine.startDate;
      return medicineDate == targetDate;
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

  Future<void> getUserMedicinesList({int? page, int? pageSize}) async {
    // If loading more, set the flag
    if (page != null && page > 1) {
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(state.copyWith(requestStatus: RequestStatus.loading));
      currentPage = 1;
      hasMore = true;
    }

    final result = await _medicinesViewRepo.getAllMedicines(
        language: AppStrings.arabicLang,
        userType: 'Patient',
        page: page ?? currentPage,
        pageSize: pageSize ?? this.pageSize);

    result.when(success: (response) {
      final newMedicines = response.medicineList;

      // Update hasMore based on whether we got a full page of results
      hasMore = newMedicines.length >= (pageSize ?? this.pageSize);

      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        userMedicines: page == 1 || page == null
            ? newMedicines
            : [...state.userMedicines, ...newMedicines],
        responseMessage: response.message,
        isLoadingMore: false,
      ));

      if (page == null || page == 1) {
        currentPage = 1;
      } else {
        currentPage = page;
      }
    }, failure: (error) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
        responseMessage: error.errors.first,
        isLoadingMore: false,
      ));
    });
  }

  Future<void> loadMoreMedicines() async {
    if (!hasMore || isLoadingMore) return;

    await getUserMedicinesList(page: currentPage + 1);
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

  Future<void> cancelAlarmsCreatedBeforePerMedicine(String medicineName) async {
    final alarmsId = getAlarmsForMedicine(medicineName);
    for (final id in alarmsId) {
      await Alarm.stop(id);
    }
    await removeMedicineAlarms(medicineName);
  }

  List<int> getAlarmsForMedicine(String medicineName) {
    final box = Hive.box<List<MedicineAlarmModel>>(
        MedicinesApiConstants.alarmsScheduledPerMedicineBoxKey);

    final medicineAlarms = box.values.first;

    if (medicineAlarms.isEmpty) return [];

    final medicineAlarmsId = medicineAlarms.firstWhere(
      (storedMedcine) => storedMedcine.medicineName == medicineName,
    );
    return medicineAlarmsId.alarmId;
  }

  Future<void> removeMedicineAlarms(String medicineName) async {
    final box = Hive.box<List<MedicineAlarmModel>>(
        MedicinesApiConstants.alarmsScheduledPerMedicineBoxKey);

    if (box.isEmpty) return;

    final key = box.keys.first;
    final alarms = List<MedicineAlarmModel>.from(box.get(key)!);

    alarms.removeWhere((model) => model.medicineName == medicineName);

    await box.put(key, alarms);
    log('Removed alarms for $medicineName');
  }
}
