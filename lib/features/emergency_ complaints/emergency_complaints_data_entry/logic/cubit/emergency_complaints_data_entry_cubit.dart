import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';

import '../../../data/repos/emergency_complaints_data_entry_repo.dart';

part 'emergency_complaints_data_entry_state.dart';

class EmergencyComplaintsDataEntryCubit
    extends Cubit<EmergencyComplaintsDataEntryState> {
  EmergencyComplaintsDataEntryCubit(this._emergencyDataEntryRepo)
      : super(
          EmergencyComplaintsDataEntryState.initialState(),
        );
  final EmergencyComplaintsDataEntryRepo _emergencyDataEntryRepo;

  final formKey = GlobalKey<FormState>();

  /// Update Field Values
  void updateDateOfComplaint(String? date) {
    emit(state.copyWith(complaintAppearanceDate: date));
    validateRequiredFields();
  }

  void updateDoctorName(String? doctorName) {
    emit(state.copyWith(doctorNameSelection: doctorName));
    validateRequiredFields();
  }

  void updateDoctorSpeciality(String? speciality) {
    emit(state.copyWith(doctorSpecialitySelection: speciality));
    validateRequiredFields();
  }

  //! crash app when user try get into page and go back in afew seconds , gives me error state emitted after cubit closed
  Future<void> intialRequestsForEmergencyDataEntry() async {}

  void validateRequiredFields() {
    if (state.complaintAppearanceDate == null ||
        state.doctorNameSelection == null ||
        state.doctorSpecialitySelection == null) {
      emit(
        state.copyWith(
          isFormValidated: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isFormValidated: true,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    formKey.currentState?.reset();
    return super.close();
  }
}
