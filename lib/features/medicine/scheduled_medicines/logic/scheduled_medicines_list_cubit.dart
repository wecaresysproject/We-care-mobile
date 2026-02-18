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

  /// Safely reads all medicine alarms from Hive using a stable key.
  List<MedicineAlarmModel> _getAllAlarms() {
    final box = Hive.box<List<MedicineAlarmModel>>(
        MedicinesApiConstants.alarmsScheduledPerMedicineBoxKey);
    return List<MedicineAlarmModel>.from(box.get('medicines') ?? []);
  }

  Future<void> loadScheduledMedicines() async {
    emit(state.copyWith(loadingStatus: RequestStatus.loading));

    try {
      final medicineAlarms = _getAllAlarms();

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
    final allAlarms = _getAllAlarms();
    if (allAlarms.isEmpty) return [];

    try {
      final match = allAlarms.firstWhere(
        (m) => m.medicineName == medicineName,
      );
      return match.alarmId;
    } catch (e) {
      return [];
    }
  }

  Future<void> _removeMedicineAlarms(String medicineName) async {
    final box = Hive.box<List<MedicineAlarmModel>>(
        MedicinesApiConstants.alarmsScheduledPerMedicineBoxKey);

    final alarms = _getAllAlarms();
    alarms.removeWhere((model) => model.medicineName == medicineName);

    await box.put('medicines', alarms);
    log('Removed alarms for $medicineName');
  }
}
