import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/emergency_complaints/data/models/emergency_complain_request_body.dart';
import 'package:we_care/features/emergency_complaints/data/models/get_single_complaint_response_model.dart'
    as model;
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';
import 'package:we_care/generated/l10n.dart';

import '../../../data/repos/emergency_complaints_data_entry_repo.dart';

part 'emergency_complaints_data_entry_state.dart';

class EmergencyComplaintsDataEntryCubit
    extends Cubit<EmergencyComplaintsDataEntryState> {
  EmergencyComplaintsDataEntryCubit(
      this._emergencyDataEntryRepo, this._appSharedRepo)
      : super(
          EmergencyComplaintsDataEntryState.initialState(),
        ) {
    additionalMedicalComplains.addListener(validateRequiredFields);
  }
  // ignore: unused_field
  final EmergencyComplaintsDataEntryRepo _emergencyDataEntryRepo;
  final AppSharedRepo _appSharedRepo;
  final personalInfoController = TextEditingController();
  final additionalMedicalComplains = TextEditingController();
  final complaintDiagnosisController = TextEditingController(); // التشخيص

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
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> emitAllMedicinesNames() async {
    final response = await _emergencyDataEntryRepo.getAllMedicinesNames(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );
    response.when(
      success: (medcineNames) {
        emit(
          state.copyWith(
            medicines: medcineNames,
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

  void removeUploadedComplainsImage(String url) {
    final updated = List<String>.from(state.uploadedComplainsImages)
      ..remove(url);

    emit(
      state.copyWith(
        uploadedComplainsImages: updated,
        message: "تم حذف الصورة",
      ),
    );
  }

  Future<void> uploadComplainsImage({required String imagePath}) async {
    // 1) Check limit
    if (state.uploadedComplainsImages.length >= 8) {
      emit(
        state.copyWith(
          message: "لقد وصلت للحد الأقصى لرفع الصور (8)",
          uploadImageRequestStatus: UploadImageRequestStatus.failure,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        uploadImageRequestStatus: UploadImageRequestStatus.initial,
      ),
    );
    final response = await _appSharedRepo.uploadImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        // add URL to existing list
        final xrayImages = List<String>.from(state.uploadedComplainsImages)
          ..add(response.imageUrl);

        emit(
          state.copyWith(
            message: response.message,
            uploadedComplainsImages: xrayImages,
            uploadImageRequestStatus: UploadImageRequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            uploadImageRequestStatus: UploadImageRequestStatus.failure,
          ),
        );
      },
    );
  }

  void updateSelectedMedicineName(String medicine) {
    emit(
      state.copyWith(
        selectedMedicineName: medicine,
      ),
    );
  }

  Future<void> updateSpecifcEmergencyDocumentDataDetails(S locale) async {
    emit(
      state.copyWith(
        emergencyComplaintsDataEntryStatus: RequestStatus.loading,
      ),
    );
    final result =
        await _emergencyDataEntryRepo.editSpecifcEmergencyDocumentDataDetails(
      requestBody: EmergencyComplainRequestBody(
        complainsImages: state.uploadedComplainsImages,
        additionalMedicalComplains: additionalMedicalComplains.text,
        dateOfComplaint: state.complaintAppearanceDate!,
        medication: Medications(
          medicationName: state.secondQuestionAnswer
              ? state.selectedMedicineName!
              : locale.no_data_entered,
          dosage: state.secondQuestionAnswer
              ? medicineDoseController.text
              : locale.no_data_entered,
        ),
        similarComplaint: SimilarComplaint(
          diagnosis: state.firstQuestionAnswer
              ? complaintDiagnosisController.text
              : locale.no_data_entered,
          dateOfComplaint: state.firstQuestionAnswer
              ? state.previousComplaintDate!
              : locale.no_data_entered,
        ),
        emergencyIntervention: EmergencyIntervention(
          interventionType: state.thirdQuestionAnswer
              ? emergencyInterventionTypeController.text
              : locale.no_data_entered,
          interventionDate: state.thirdQuestionAnswer
              ? state.emergencyInterventionDate!
              : locale.no_data_entered,
        ),
        userMedicalComplaint: state.medicalComplaints,
        personalNote: personalInfoController.text,
      ),
      language: AppStrings.arabicLang,
      documentId: state.updatedDocumentId,
    );
    result.when(
      success: (successMessage) async {
        emit(
          state.copyWith(
            emergencyComplaintsDataEntryStatus: RequestStatus.success,
            message: successMessage,
          ),
        );
      },
      failure: (message) {
        emit(
          state.copyWith(
            emergencyComplaintsDataEntryStatus: RequestStatus.failure,
            message: message.errors.first,
          ),
        );
      },
    );
  }

// when we send list of complaints=> ensure that i send
  Future<void> loadComplaintForEditing(
    model.DetailedComplaintModel emergencyComplaint,
    S locale,
  ) async {
    await storeTempUserPastComplaints(emergencyComplaint.mainSymptoms);

    // return null;
    var firstQuestionAnswer = emergencyComplaint.similarComplaint.diagnosis !=
                locale.no_data_entered ||
            emergencyComplaint.similarComplaint.dateOfComplaint !=
                locale.no_data_entered
        ? true
        : false;
    complaintDiagnosisController.text;
    var secondQuestionAnswer = emergencyComplaint.medications.medicationName !=
                locale.no_data_entered ||
            emergencyComplaint.medications.dosage != locale.no_data_entered
        ? true
        : false;
    var thirdQuestionAnswer =
        emergencyComplaint.emergencyIntervention.interventionType !=
                    locale.no_data_entered ||
                emergencyComplaint.emergencyIntervention.interventionDate !=
                    locale.no_data_entered
            ? true
            : false;

    emit(
      state.copyWith(
        complaintAppearanceDate: emergencyComplaint.date,
        medicalComplaints: emergencyComplaint.mainSymptoms,
        firstQuestionAnswer: firstQuestionAnswer,
        secondQuestionAnswer: secondQuestionAnswer,
        thirdQuestionAnswer: thirdQuestionAnswer,
        previousComplaintDate:
            emergencyComplaint.similarComplaint.dateOfComplaint,
        emergencyInterventionDate:
            emergencyComplaint.emergencyIntervention.interventionDate,
        hasSimilarComplaintBefore: firstQuestionAnswer ? 'نعم' : 'لا',
        isCurrentlyTakingMedication: secondQuestionAnswer ? 'نعم' : 'لا',
        hasReceivedEmergencyCareBefore: thirdQuestionAnswer ? 'نعم' : 'لا',
        isEditMode: true,
        updatedDocumentId: emergencyComplaint.id,
        selectedMedicineName: emergencyComplaint.medications.medicationName,
        uploadedComplainsImages: emergencyComplaint.complainsImages,
      ),
    );
    complaintDiagnosisController.text =
        emergencyComplaint.similarComplaint.diagnosis == locale.no_data_entered
            ? ''
            : emergencyComplaint.similarComplaint.diagnosis;
    medicineDoseController.text =
        emergencyComplaint.medications.dosage == locale.no_data_entered
            ? ''
            : emergencyComplaint.medications.dosage;
    emergencyInterventionTypeController.text =
        emergencyComplaint.emergencyIntervention.interventionType ==
                locale.no_data_entered
            ? ''
            : emergencyComplaint.emergencyIntervention.interventionType;
    personalInfoController.text =
        emergencyComplaint.personalNote == locale.no_data_entered
            ? ''
            : emergencyComplaint.personalNote;
    additionalMedicalComplains.text =
        emergencyComplaint.additionalMedicalComplains == locale.no_data_entered
            ? ''
            : emergencyComplaint.additionalMedicalComplains ?? '';
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

  Future<void> postEmergencyDataEntry(S locale) async {
    emit(
      state.copyWith(
        emergencyComplaintsDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response = await _emergencyDataEntryRepo.postEmergencyDataEntry(
      requestBody: EmergencyComplainRequestBody(
        complainsImages: state.uploadedComplainsImages,
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
        additionalMedicalComplains: additionalMedicalComplains.text.isEmpty
            ? locale.no_data_entered
            : additionalMedicalComplains.text,
        medication: Medications(
          medicationName: state.selectedMedicineName ?? locale.no_data_entered,
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
    emit(
      state.copyWith(
        emergencyComplaintsDataEntryStatus: RequestStatus.initial,
      ),
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
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> removeAddedMedicalComplaint(int index) async {
    final Box<MedicalComplaint> medicalComplaintsBox =
        Hive.box<MedicalComplaint>("medical_complaints");

    if (index < 0 || index >= medicalComplaintsBox.length) return;

    await medicalComplaintsBox.deleteAt(index);

    final updatedComplaints = medicalComplaintsBox.values.toList();

    //* in order to validate after that if there is at least one medical complaints , to ennable save button or not
    emit(
      state.copyWith(medicalComplaints: updatedComplaints),
    );

    validateRequiredFields();
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

  Future<bool> updateIsTakingMedicines(String? result) async {
    bool isTakingMedicine = result == 'نعم';

    emit(
      state.copyWith(
        isCurrentlyTakingMedication: result,
        secondQuestionAnswer: isTakingMedicine,
      ),
    );

    validateRequiredFields(); // Ensure validation runs
    await emitAllMedicinesNames();
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
        state.hasReceivedEmergencyCareBefore == null ||
        (state.medicalComplaints.isEmpty &&
            additionalMedicalComplains.text.isEmpty)) {
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
    additionalMedicalComplains.removeListener(validateRequiredFields);
    personalInfoController.dispose();
    complaintDiagnosisController.dispose();
    medicineDoseController.dispose();
    emergencyInterventionTypeController.dispose();
    additionalMedicalComplains.dispose();
    await clearAllAddedComplaints();
    return super.close();
  }
}
