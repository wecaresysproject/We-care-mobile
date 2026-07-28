import 'dart:developer';

import 'package:alarm/alarm.dart';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/medicine/data/models/get_all_user_medicines_responce_model.dart';
import 'package:we_care/features/medicine/data/models/medicine_alarm_model.dart';
import 'package:we_care/features/medicine/data/repos/medicine_view_repo.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_state.dart';
import 'package:we_care/features/medicine/medicines_api_constants.dart';

class MedicineViewCubit extends Cubit<MedicineViewState> with SafeEmitMixin {
  MedicineViewCubit(this._medicinesViewRepo, this._appSharedRepo)
      : super(MedicineViewState.initial());
  final MedicinesViewRepo _medicinesViewRepo;
  final AppSharedRepo _appSharedRepo;
  int currentPage = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool isLoadingMore = false;

  Future<void> init() async {
    await Future.wait(
      [
        getMedicinesFilters(),
        getUserMedicinesList(page: 1, pageSize: 10),
        emitModuleGuidance(),
      ],
    );
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

  Future<void> initialRequests(String documentId) async {
    await Future.wait([
      getMedicineDetailsById(documentId),
      fetchMedicineActiveStatus(documentId),
    ]);
  }

  Future<void> emitModuleGuidance() async {
    final result = await _appSharedRepo
        .getModuleGuidance(WeCareMedicalModules.medicationsView.name);
    result.when(
      success: (data) {
        emit(state.copyWith(moduleGuidanceData: data));
      },
      failure: (error) {
        emit(state.copyWith(moduleGuidanceData: null));
      },
    );
  }

  Future<void> getMedicineDetailsById(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _medicinesViewRepo.getMedicineById(
        id: id, language: AppStrings.arabicLang, userType: 'Patient');

    result.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        selectedMedicineDetails: response,
        //* second source for the end date: the medicine record itself carries it
        //* when one was set. Null is a no-op in copyWith, so whichever of this
        //* and the status request answers with a date wins.
        medicineEndDate: response.endDate,
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

  Future<void> fetchMedicineActiveStatus(String medicineId) async {
    safeEmit(state.copyWith(isSwitchLoading: true, switchErrorMessage: ''));
    final result = await _medicinesViewRepo.getMedicineActiveStatus(
      medicineId: medicineId,
      userType: 'Patient',
      language: AppStrings.arabicLang,
    );
    result.when(
      success: (status) {
        safeEmit(
          state.copyWith(
            isSwitchLoading: false,
            isStatusResolved: true,
            isActiveMedicine: status.isActiveMedicine,
            medicineEndDate: status.endDate,
          ),
        );
      },
      failure: (error) {
        //* isStatusResolved stays false: a failed fetch must never be shown as "ended".
        safeEmit(
          state.copyWith(
            isSwitchLoading: false,
            switchErrorMessage: error.errors.isNotEmpty
                ? error.errors.first
                : 'تعذر تحميل حالة استمرارية الدواء',
          ),
        );
      },
    );
  }

  /// Ends the medicine: calls UpdateMedicineStatus with `isActiveMedicine: false`
  /// and the user-picked [endDate] ('yyyy-MM-dd') collected in the confirmation
  /// dialog. The medicine is treated as ended, and its alarms cancelled, only
  /// after the API confirms it. Returns true when the medicine is ended.
  Future<bool> endMedicine({
    required String medicineId,
    required String endDate,
  }) async {
    if (state.isSwitchLoading) return false; //* re-entrancy guard
    if (state.isStatusResolved && !state.isActiveMedicine) {
      return false; //* already ended
    }

    //* alarms are keyed by medicine name, so capture it before awaiting
    final medicineName = state.selectestMedicineDetails?.medicineName;

    //* no optimistic flip: isActiveMedicine/medicineEndDate are written on success only
    safeEmit(state.copyWith(isSwitchLoading: true, switchErrorMessage: ''));

    final result = await _medicinesViewRepo.updateMedicineStatus(
      medicineId: medicineId,
      userType: 'Patient',
      language: AppStrings.arabicLang,
      isActiveMedicine: false,
      endDate: endDate,
    );

    bool succeeded = false;
    result.when(
      success: (status) {
        succeeded = !status.isActiveMedicine;
        safeEmit(
          state.copyWith(
            isSwitchLoading: false,
            isStatusResolved: true,
            isActiveMedicine: status.isActiveMedicine,
            medicineEndDate: status.endDate ?? endDate,
            switchErrorMessage:
                succeeded ? '' : 'تعذر إنهاء الدواء، حاول مرة أخرى',
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            isSwitchLoading: false,
            switchErrorMessage: error.errors.isNotEmpty
                ? error.errors.first
                : 'تعذر إنهاء الدواء، حاول مرة أخرى',
          ),
        );
      },
    );

    //* only reachable when the API confirmed the medicine is ended
    if (succeeded && medicineName != null && medicineName.isNotEmpty) {
      await cancelAlarmsCreatedBeforePerMedicine(medicineName);
    }
    return succeeded;
  }

  Future<void> cancelAlarmsCreatedBeforePerMedicine(String medicineName) async {
    try {
      final alarmsId = getAlarmsForMedicine(medicineName);
      for (final id in alarmsId) {
        await Alarm.stop(id);
      }
      await removeMedicineAlarms(medicineName);
    } catch (error) {
      //* a local alarm failure must not surface as a failed request
      AppLogger.error('Failed to cancel alarms for $medicineName: $error');
    }
  }

  List<int> getAlarmsForMedicine(String medicineName) {
    final box =
        Hive.box(MedicinesApiConstants.alarmsScheduledPerMedicineBoxKey);

    final medicineAlarms =
        List<MedicineAlarmModel>.from(box.get('medicines') ?? []);

    if (medicineAlarms.isEmpty) return [];

    final medicineAlarm = medicineAlarms.firstWhere(
      (storedMedicine) => storedMedicine.medicineName == medicineName,
      orElse: () => MedicineAlarmModel(medicineName: '', alarmId: []),
    );

    return medicineAlarm.alarmId;
  }

  Future<void> removeMedicineAlarms(String medicineName) async {
    final box =
        Hive.box(MedicinesApiConstants.alarmsScheduledPerMedicineBoxKey);

    final alarms = List<MedicineAlarmModel>.from(box.get('medicines') ?? []);

    alarms.removeWhere((model) => model.medicineName == medicineName);

    await box.put('medicines', alarms);
    log('Removed alarms for $medicineName');
  }
}
