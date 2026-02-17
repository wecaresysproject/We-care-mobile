import 'dart:developer';

import 'package:alarm/alarm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/medicine/data/models/medicine_alarm_model.dart';
import 'package:we_care/features/medicine/medicines_api_constants.dart';
import 'package:we_care/features/medicine/scheduled_medicines/logic/scheduled_medicines_list_state.dart';

class ScheduledMedicinesListCubit extends Cubit<ScheduledMedicinesListState> {
  ScheduledMedicinesListCubit() : super(ScheduledMedicinesListState.initial());

  Future<void> loadScheduledMedicines() async {
    emit(state.copyWith(loadingStatus: RequestStatus.loading));

    try {
      final box = Hive.box<List<MedicineAlarmModel>>(
          MedicinesApiConstants.alarmsScheduledPerMedicineBoxKey);

      if (box.isEmpty) {
        emit(state.copyWith(
          scheduledMedicines: [],
          loadingStatus: RequestStatus.success,
        ));
        return;
      }

      final medicineAlarms = box.values.first;

      emit(state.copyWith(
        scheduledMedicines: medicineAlarms,
        loadingStatus: RequestStatus.success,
      ));
    } catch (e) {
      log('Error loading scheduled medicines: $e');
      emit(state.copyWith(
        errorMessage: 'فشل في تحميل الأدوية المجدولة',
        loadingStatus: RequestStatus.failure,
      ));
    }
  }

  Future<void> cancelMedicineAlarms(String medicineName) async {
    try {
      // Get alarm IDs for this medicine
      final alarmIds = _getAlarmsForMedicine(medicineName);

      // Stop each alarm
      for (final id in alarmIds) {
        await Alarm.stop(id);
        log('Stopped alarm with ID: $id for medicine: $medicineName');
      }

      // Remove from Hive storage
      await _removeMedicineAlarms(medicineName);

      // Reload the list
      await loadScheduledMedicines();
    } catch (e) {
      log('Error canceling medicine alarms: $e');
      emit(state.copyWith(
        errorMessage: 'فشل في إلغاء التنبيه',
        loadingStatus: RequestStatus.failure,
      ));
    }
  }

  List<int> _getAlarmsForMedicine(String medicineName) {
    final box = Hive.box<List<MedicineAlarmModel>>(
        MedicinesApiConstants.alarmsScheduledPerMedicineBoxKey);

    if (box.isEmpty) return [];

    final medicineAlarms = box.values.first;

    if (medicineAlarms.isEmpty) return [];

    try {
      final medicineAlarmsId = medicineAlarms.firstWhere(
        (storedMedicine) => storedMedicine.medicineName == medicineName,
      );
      return medicineAlarmsId.alarmId;
    } catch (e) {
      return [];
    }
  }

  Future<void> _removeMedicineAlarms(String medicineName) async {
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
