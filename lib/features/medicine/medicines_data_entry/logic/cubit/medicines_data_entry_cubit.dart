import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';
import 'package:we_care/features/medicine/data/models/get_all_user_medicines_responce_model.dart';
import 'package:we_care/features/medicine/data/models/medicine_data_entry_request_body.dart';
import 'package:we_care/features/medicine/data/repos/medicine_data_entry_repo.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_state.dart';
import 'package:we_care/generated/l10n.dart';

class MedicinesDataEntryCubit extends Cubit<MedicinesDataEntryState> {
  MedicinesDataEntryCubit(this._medicinesDataEntryRepo)
      : super(
          MedicinesDataEntryState.initialState(),
        );
  final MedicinesDataEntryRepo _medicinesDataEntryRepo;
  final personalInfoController = TextEditingController();
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
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> loadMedicinesDataEnteredForEditing(
    MedicineModel pastDataEntered,
  ) async {
    await storeTempUserPastComplaints(pastDataEntered.mainSymptoms);

    emit(
      state.copyWith(
        medicineStartDate: pastDataEntered.startDate,
        selectedMedicineName: pastDataEntered.medicineName,
        selectedMedicalForm: pastDataEntered.usageMethod,
        selectedDose: pastDataEntered.dosage,
        selectedNoOfDose: pastDataEntered.dosageFrequency,
        doseDuration: pastDataEntered.usageDuration,
        timePeriods: pastDataEntered.timeDuration,
        selectedChronicDisease: pastDataEntered.chronicDiseaseMedicine,
        medicalComplaints: pastDataEntered.mainSymptoms,
        selectedDoctorName: pastDataEntered.doctorName,
        selectedAlarmTime: pastDataEntered.reminder,
        isEditMode: true,
        updatedDocumentId: pastDataEntered.id,
      ),
    );
    personalInfoController.text = pastDataEntered.personalNotes;
    validateRequiredFields();
    await initialDataEntryRequests();
  }

  Future<void> storeTempUserPastComplaints(
      List<MedicalComplaint> emergencyComplaints) async {
    final medicalComplaintBox =
        Hive.box<MedicalComplaint>("medical_complaints");

    // Loop through the list and store each complaint in the box
    for (var oldComplains in emergencyComplaints) {
      await medicalComplaintBox.add(oldComplains);
    }
  }

  Future<void> submitEditsForMedicine() async {
    emit(
      state.copyWith(
        medicinesDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response =
        await _medicinesDataEntryRepo.editSpecifcMedicineDataDetails(
      medicineId: state.updatedDocumentId,
      requestBody: MedicineDataEntryRequestBody(
        startDate: state.medicineStartDate!,
        medicineName: state.selectedMedicineName!,
        usageMethod: state.selectedMedicalForm!,
        dosage: state.selectedDose!,
        dosageFrequency: state.selectedNoOfDose!,
        usageDuration: state.doseDuration!,
        timeDuration: state.timePeriods!,
        chronicDiseaseMedicine: state.selectedChronicDisease!,
        doctorName: state.selectedDoctorName!,
        reminder: state.selectedAlarmTime!,
        reminderStatus: state.selectedAlarmTime.isNotNull ? true : false,
        personalNotes: personalInfoController.text,
        userMedicalComplaint: state.medicalComplaints,
      ),
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );

    response.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            medicinesDataEntryStatus: RequestStatus.success,
            message: successMessage,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            medicinesDataEntryStatus: RequestStatus.failure,
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> initialDataEntryRequests() async {
    await emitAllMedicinesNames();
    await emitAllDosageFrequencies();
    await getAllUsageCategories();
  }

  Future<void> emitAllMedicinesNames() async {
    final response = await _medicinesDataEntryRepo.getAllMedicinesNames(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );
    response.when(
      success: (response) {
        final medcineNames = response.map((e) => e.tradeName).toList();
        emit(
          state.copyWith(
            medicinesNames: medcineNames,
            medicinesBasicInfo: response,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  void getMedcineIdByName(String selectedMedicineName) {
    for (final medcineInfo in state.medicinesBasicInfo!) {
      if (medcineInfo.tradeName == selectedMedicineName) {
        emit(
          state.copyWith(
            medicineId: medcineInfo.id,
          ),
        );
        return;
      }
    }
  }

  Future<void> emitMedicineforms() async {
    final response = await _medicinesDataEntryRepo.getMedcineForms(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      medicineId: state.medicineId,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            medicineForms: response,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> emitMedcineDosesByForms() async {
    final response = await _medicinesDataEntryRepo.getMedcineDosesByForms(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name,
      medicineId: state.medicineId,
      medicineForm: state.selectedMedicalForm ?? "", //TODO: handle this later
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            medicalDoses: response,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> emitAllDosageFrequencies() async {
    final response = await _medicinesDataEntryRepo.getAllDosageFrequencies(
      langauge: AppStrings.arabicLang,
      userType: UserTypes.patient.name,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            dosageFrequencies: response,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> getAllUsageCategories() async {
    final response = await _medicinesDataEntryRepo.getAllUsageCategories(
      langauge: AppStrings.arabicLang,
      userType: UserTypes.patient.name,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            allUsageCategories: response,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> emitAllDurationsForCategory() async {
    final response = await _medicinesDataEntryRepo.getAllDurationsForCategory(
      langauge: AppStrings.arabicLang,
      userType: UserTypes.patient.name,
      category: state.doseDuration!,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            allDurationsBasedOnCategory: response,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> getMedicineDetails(String medicineId) async {
    final response = await _medicinesDataEntryRepo.getMedicineDetailsById(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name,
      medicineId: medicineId,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
              // medicineDetails: response,
              ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> postMedicinesDataEntry(S locale) async {
    emit(
      state.copyWith(
        medicinesDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response = await _medicinesDataEntryRepo.postMedicinesDataEntry(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      requestBody: MedicineDataEntryRequestBody(
        startDate: state.medicineStartDate!,
        medicineName: state.selectedMedicineName!,
        usageMethod: state.selectedMedicalForm!,
        dosage: state.selectedDose!,
        dosageFrequency: state.selectedNoOfDose!,
        usageDuration: state.doseDuration!,
        timeDuration: state.timePeriods!,
        chronicDiseaseMedicine: locale.no_data_entered,
        doctorName: state.selectedDoctorName ?? locale.no_data_entered,
        reminder: state.selectedAlarmTime ?? locale.no_data_entered,
        reminderStatus: state.selectedAlarmTime.isNotNull ? true : false,
        personalNotes: personalInfoController.text.isNotEmpty
            ? personalInfoController.text
            : locale.no_data_entered,
        userMedicalComplaint: state.medicalComplaints,
      ),
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            message: successMessage,
            medicinesDataEntryStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            medicinesDataEntryStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> removeAddedMedicalComplaint(int index) async {
    final Box<MedicalComplaint> medicalComplaintsBox =
        Hive.box<MedicalComplaint>("medical_complaints");

    if (index >= 0 && index < medicalComplaintsBox.length) {
      await medicalComplaintsBox.deleteAt(index);
    }
  }

  Future<void> clearAllAddedComplaints() async {
    try {
      final medicalComplaintBox =
          Hive.box<MedicalComplaint>("medical_complaints");
      await medicalComplaintBox.clear();
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString(),
        ),
      );
    }
  }

  void updateSelectedAlarmTime(String? alarmTime) {
    emit(
      state.copyWith(
        selectedAlarmTime: alarmTime,
      ),
    );
  }

  /// Update Field Values
  void updateStartMedicineDate(String? date) {
    emit(state.copyWith(medicineStartDate: date));
    validateRequiredFields();
  }

  Future<void> updateSelectedMedicineName(String? medicineName) async {
    emit(state.copyWith(selectedMedicineName: medicineName));
    validateRequiredFields();
    getMedcineIdByName(medicineName!);
    await emitMedicineforms();
  }

  Future<void> updateSelectedMedicalForm(String? form) async {
    emit(state.copyWith(selectedMedicalForm: form));
    await emitMedcineDosesByForms();
    validateRequiredFields();
  }

  void updateSelectedDose(String? dose) {
    emit(state.copyWith(selectedDose: dose));
    validateRequiredFields();
  }

  void updateSelectedDoseFrequency(String? noOfDose) {
    emit(state.copyWith(selectedNoOfDose: noOfDose));
    validateRequiredFields();
  }

  Future<void> updateSelectedDoseDuration(String? doseDuration) async {
    emit(state.copyWith(doseDuration: doseDuration));
    await emitAllDurationsForCategory();
    validateRequiredFields();
  }

  void updateSelectedTimePeriod(String? timePeriods) {
    emit(state.copyWith(timePeriods: timePeriods));
    validateRequiredFields();
  }

  void updateSelectedChronicDisease(String? value) {
    emit(state.copyWith(selectedChronicDisease: value));
  }

  void updateSelectedDoctorName(String? value) {
    emit(state.copyWith(selectedDoctorName: value));
  }

  void validateRequiredFields() {
    if (state.medicineStartDate == null ||
        state.selectedMedicineName == null ||
        state.selectedMedicalForm == null ||
        state.selectedDose == null ||
        state.selectedNoOfDose == null ||
        state.doseDuration == null ||
        state.timePeriods == null) {
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
  Future<void> close() async {
    personalInfoController.dispose();
    await clearAllAddedComplaints();
    return super.close();
  }
}
