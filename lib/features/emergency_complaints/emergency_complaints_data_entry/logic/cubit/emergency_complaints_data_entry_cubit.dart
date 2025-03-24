import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/emergency_complaints/data/models/emergency_complain_request_body.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';
import 'package:we_care/generated/l10n.dart';

import '../../../data/repos/emergency_complaints_data_entry_repo.dart';

part 'emergency_complaints_data_entry_state.dart';

class EmergencyComplaintsDataEntryCubit
    extends Cubit<EmergencyComplaintsDataEntryState> {
  EmergencyComplaintsDataEntryCubit(this._emergencyDataEntryRepo)
      : super(
          EmergencyComplaintsDataEntryState.initialState(),
        );
  // ignore: unused_field
  final EmergencyComplaintsDataEntryRepo _emergencyDataEntryRepo;
  final personalInfoController = TextEditingController();
  final complaintDiagnosisController = TextEditingController(); // التشخيص

  final medicineNameController = TextEditingController(); // اسم الدواء
  final medicineDoseController = TextEditingController(); // الجرعه
  final emergencyInterventionTypeController =
      TextEditingController(); // نوع التدخل
  List<MedicalComplaint> medicalComplaints = [];
  Future<void> fetchAllAddedComplaints() async {
    try {
      final medicalComplaintBox =
          Hive.box<MedicalComplaint>("medical_complaints");
      medicalComplaints = medicalComplaintBox.values.toList(growable: true);
      emit(
        state.copyWith(
          medicalComplaints: medicalComplaints,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          medicalComplaints: [],
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> postEmergencyDataEntry(S locale) async {
    emit(
      state.copyWith(
        emergencyComplaintsDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response = await _emergencyDataEntryRepo.postEmergencyDataEntry(
      requestBody: EmergencyComplainRequestBody(
        dateOfComplaint: state.complaintAppearanceDate!,
        userMedicalComplaint:
            state.medicalComplaints.isEmpty ? [] : state.medicalComplaints,
        similarComplaint: SimilarComplaint(
          dateOfComplaint:
              state.previousComplaintDate ?? locale.no_data_entered,
          diagnosis: complaintDiagnosisController.text.isEmpty
              ? locale.no_data_entered
              : complaintDiagnosisController.text,
        ),
        personalNote: personalInfoController.text.isEmpty
            ? locale.no_data_entered
            : personalInfoController.text,
        medication: Medication(
          medicationName: medicineNameController.text.isEmpty
              ? locale.no_data_entered
              : medicineNameController.text,
          dosage: medicineDoseController.text.isEmpty
              ? locale.no_data_entered
              : medicineDoseController.text,
        ),
        emergencyIntervention: EmergencyIntervention(
          interventionType: emergencyInterventionTypeController.text.isEmpty
              ? locale.no_data_entered
              : emergencyInterventionTypeController.text,
          interventionDate:
              state.emergencyInterventionDate ?? locale.no_data_entered,
        ),
      ),
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            emergencyComplaintsDataEntryStatus: RequestStatus.success,
            message: successMessage,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            emergencyComplaintsDataEntryStatus: RequestStatus.failure,
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> clearAllAddedComplaints() async {
    try {
      final medicalComplaintBox =
          Hive.box<MedicalComplaint>("medical_complaints");
      await medicalComplaintBox.clear();
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> removeAddedMedicalComplaint(int index) async {
    final Box<MedicalComplaint> medicalComplaintsBox =
        Hive.box<MedicalComplaint>("medical_complaints");

    if (index >= 0 && index < medicalComplaintsBox.length) {
      await medicalComplaintsBox.deleteAt(index);
    }
  }

  /// Update Field Values
  void updateDateOfComplaint(String? date) {
    emit(state.copyWith(complaintAppearanceDate: date));
    validateRequiredFields();
  }

  void updateIfHasSameComplaintBeforeDate(String? date) {
    emit(state.copyWith(previousComplaintDate: date));
  }

  void updateEmergencyInterventionDate(String? date) {
    emit(state.copyWith(emergencyInterventionDate: date));
  }

  bool updateHasPreviousComplaintBefore(String? result) {
    bool hasComplaint = result == 'نعم';

    emit(
      state.copyWith(
        hasSimilarComplaintBefore: result,
        firstQuestionAnswer: hasComplaint,
      ),
    );

    validateRequiredFields(); // Ensure this method is called

    return hasComplaint;
  }

  bool updateIsTakingMedicines(String? result) {
    bool isTakingMedicine = result == 'نعم';

    emit(
      state.copyWith(
        isCurrentlyTakingMedication: result,
        secondQuestionAnswer: isTakingMedicine,
      ),
    );

    validateRequiredFields(); // Ensure validation runs

    return isTakingMedicine;
  }

  bool updateHasReceivedEmergencyCareBefore(String? result) {
    bool hasReceivedCare = result == 'نعم';

    emit(state.copyWith(
      hasReceivedEmergencyCareBefore: result,
      thirdQuestionAnswer: hasReceivedCare,
    ));

    validateRequiredFields(); // Ensure validation runs

    return hasReceivedCare;
  }

  void validateRequiredFields() {
    if (state.complaintAppearanceDate == null ||
        state.hasSimilarComplaintBefore == null ||
        state.isCurrentlyTakingMedication == null ||
        state.hasReceivedEmergencyCareBefore == null) {
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
    personalInfoController.dispose();
    complaintDiagnosisController.dispose();
    medicineNameController.dispose();
    medicineDoseController.dispose();
    emergencyInterventionTypeController.dispose();

    return super.close();
  }
}
