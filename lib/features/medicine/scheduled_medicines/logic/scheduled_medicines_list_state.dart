import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/medicine/data/models/medicine_alarm_model.dart';

part 'scheduled_medicines_list_state.freezed.dart';

@freezed
class ScheduledMedicinesListState with _$ScheduledMedicinesListState {
  const factory ScheduledMedicinesListState({
    @Default([]) List<MedicineAlarmModel> scheduledMedicines,
    @Default(RequestStatus.initial) RequestStatus loadingStatus,
    @Default('') String errorMessage,
  }) = _ScheduledMedicinesListState;

  factory ScheduledMedicinesListState.initial() =>
      const ScheduledMedicinesListState();
}
