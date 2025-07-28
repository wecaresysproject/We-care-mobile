import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_request_body.dart';
import 'package:we_care/features/medical_illnesses/data/repos/mental_illnesses_data_entry_repo.dart';
import 'package:we_care/generated/l10n.dart';

part 'mental_illnesses_data_entry_state.dart';

class MedicalIllnessesDataEntryCubit
    extends Cubit<MedicalIllnessesDataEntryState> {
  MedicalIllnessesDataEntryCubit(this._medicalIllnessesDataEntryRepo)
      : super(
          MedicalIllnessesDataEntryState.initialState(),
        );
  final MentalIllnessesDataEntryRepo _medicalIllnessesDataEntryRepo;
  final noOfSessionsController = TextEditingController(); // عدد الجلسات
  // List<String> medicalComplaints = [];
  void addNewSymptomField() {
    final newController = TextEditingController();
    final updatedControllers =
        List<TextEditingController>.from(state.symptomControllers)
          ..add(newController);

    emit(state.copyWith(symptomControllers: updatedControllers));
  }

  void removeSymptomField(int index) {
    // Don't allow removing if only one field remains
    if (state.symptomControllers.length <= 1) return;

    if (index < state.symptomControllers.length) {
      state.symptomControllers[index].dispose();
      final updatedControllers =
          List<TextEditingController>.from(state.symptomControllers)
            ..removeAt(index);

      final updatedSymptoms = List<String>.from(state.symptoms);
      if (index < updatedSymptoms.length) {
        updatedSymptoms.removeAt(index);
      }

      emit(state.copyWith(
        symptomControllers: updatedControllers,
        symptoms: updatedSymptoms,
      ));
    }
  }

  void updateSymptom(int index, String value) {
    final updatedSymptoms = List<String>.from(state.symptoms);
    if (index < updatedSymptoms.length) {
      updatedSymptoms[index] = value;
    } else {
      // If the list is shorter, fill it up to the index
      while (updatedSymptoms.length <= index) {
        updatedSymptoms.add('');
      }
      updatedSymptoms[index] = value;
    }

    emit(state.copyWith(symptoms: updatedSymptoms));
  }

  // Future<void> loadPastEyeDataEnteredForEditing({
  //   required EyeProceduresAndSymptomsDetailsModel pastEyeData,
  //   required String id,
  // }) async {
  //   emit(
  //     state.copyWith(
  //       syptomStartDate: pastEyeData.symptomStartDate,
  //       selectedHospitalCenter: pastEyeData.centerHospitalName,
  //       selectedCountryName: pastEyeData.country,
  //       eyePartSyptomsAndProcedures: EyePartSyptomsAndProceduresResponseModel(
  //         procedures: pastEyeData.medicalProcedures,
  //         symptoms: pastEyeData.symptoms,
  //       ),
  //       symptomDuration: pastEyeData.symptomDuration,
  //       medicalExaminationImageUploadedUrl:
  //           pastEyeData.medicalExaminationImages,
  //       doctorName: pastEyeData.doctorName,
  //       isEditMode: true,
  //       editDecumentId: id,
  //       affectedEyePart: pastEyeData.affectedEyePart,
  //       reportImageUploadedUrl: pastEyeData.medicalReportUrl,
  //       procedureDateSelection: pastEyeData.medicalReportDate,
  //     ),
  //   );
  //   personalNotesController.text =
  //       pastEyeData.additionalNotes == '--' ? '' : pastEyeData.additionalNotes;

  //   validateRequiredFields();
  //   await getInitialRequests();
  // }
  Future<void> initialRequests() async {
    //! check comments later
    await Future.wait([
      emitMentalIllnessTypes(),
      emitCountriesData(),
      // emitIncidentTypes(),
      // getMedicationSideEffects(),
      // getPsychologicalEmergencies(),
      // getMedicationImpactOnDailyLife(),
      // getPreferredActivitiesForPsychologicalImprovement(),
    ]);
  }

  void updatExaminationDate(String? val) {
    emit(state.copyWith(examinationDate: val));
    validateRequiredFields();
  }

  void updateMentalIllnessesType(String? val) {
    emit(state.copyWith(selectedMentalIllnessesType: val));
    validateRequiredFields();
  }

  //! وجود حادث أو موقف له تأثير ؟
  void updateHasIncidentEffect(bool? value) {
    emit(state.copyWith(hasIncidentEffect: value));
    if (value == false) {
      emit(
        state.copyWith(
          selectedIncidentType: null,
          incidentDate: null,
          incidentEffect: null,
        ),
      );
    }
  }

  void updateFamilyRelationType(String? value) {
    emit(state.copyWith(selectedFamilyRelationType: value));
  }

//!هل يوجد حالات نفسية مشابهة فى العائلة؟
  void updateHasFamilySimilarMentalCases(bool? value) {
    emit(state.copyWith(hasFamilySimilarMentalCases: value));
    if (value == false) {
      emit(
        state.copyWith(
          selectedFamilyRelationType: null,
        ),
      );
    }
  }

  void updateIncidentType(String? value) {
    emit(state.copyWith(selectedIncidentType: value));
  }

  void updateIncidentDate(String? value) {
    emit(state.copyWith(incidentDate: value));
  }

  void updateIncidentEffect(String? value) {
    emit(state.copyWith(incidentEffect: value));
  }

// In MedicalIllnessesDataEntryCubit

  void updateIsReceivingPsychologicalTreatment(bool? value) {
    emit(state.copyWith(isReceivingPsychologicalTreatment: value));
    if (value == false) {
      emit(
        state.copyWith(
          isReceivingPsychologicalTreatment: null,
          psychologicalTreatmentType: null,
          medicationsUsed: null,
          medicationEffectOnLife: null,
          treatmentSatisfaction: null,
          psychologistName: null,
          selectedCountry: null,
          selectedHospitalName: null,
        ),
      );
      noOfSessionsController.text = '';
    }
  }

  Future<void> emitMentalIllnessTypes() async {
    final response = await _medicalIllnessesDataEntryRepo.getMentalIllnessTypes(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (mentalIllnessTypes) {
        emit(
          state.copyWith(
            mentalIllnessTypes: mentalIllnessTypes,
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

  Future<void> emitIncidentTypes() async {
    final response = await _medicalIllnessesDataEntryRepo.getIncidentTypes(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (incidentTypes) {
        emit(
          state.copyWith(
            incidentTypes: incidentTypes,
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

  Future<void> getMedicationImpactOnDailyLife() async {
    final response =
        await _medicalIllnessesDataEntryRepo.getMedicationImpactOnDailyLife(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (medicationImpactOnDailyLife) {
        emit(
          state.copyWith(
            medicationImpactOnDailyLife: medicationImpactOnDailyLife,
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

  Future<void> getPsychologicalEmergencies() async {
    final response =
        await _medicalIllnessesDataEntryRepo.getPsychologicalEmergencies(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (psychologicalEmergencies) {
        emit(
          state.copyWith(
            psychologicalEmergencies: psychologicalEmergencies,
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

  Future<void> getMedicationSideEffects() async {
    final response =
        await _medicalIllnessesDataEntryRepo.getMedicationSideEffects(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (medicationSideEffects) {
        emit(
          state.copyWith(
            medicationSideEffects: medicationSideEffects,
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

  Future<void> getPreferredActivitiesForPsychologicalImprovement() async {
    final response = await _medicalIllnessesDataEntryRepo
        .getPreferredActivitiesForPsychologicalImprovement(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (preferredActivitiesForPsychologicalImprovement) {
        emit(
          state.copyWith(
            preferredActivitiesForPsychologicalImprovement:
                preferredActivitiesForPsychologicalImprovement,
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

  void updatePsychologicalTreatmentType(String? value) {
    emit(state.copyWith(psychologicalTreatmentType: value));
  }

  void updateMedicationsUsed(String? value) {
    emit(state.copyWith(medicationsUsed: value));
  }

  void updateMedicationEffectOnLife(String? value) {
    emit(state.copyWith(medicationEffectOnLife: value));
  }

  void updateTreatmentSatisfaction(String? value) {
    emit(state.copyWith(treatmentSatisfaction: value));
  }

  void updatePsychologistName(String? value) {
    emit(state.copyWith(psychologistName: value));
  }

  void updateTreatmentCountry(String? value) {
    emit(state.copyWith(selectedCountry: value));
  }

  void updateSelectedHospitalName(String? val) {
    emit(state.copyWith(selectedHospitalName: val));
  }

  getInitialRequests() {
    // emitCountriesData();
  }

  void updateSelectedDiseaseIntensity(String? val) {
    emit(state.copyWith(selectedDiseaseIntensity: val));
  }

  void updateDiseaseDuration(String? val) {
    emit(state.copyWith(diseaseDuration: val));
  }

  void updateMentalHealthEmergency(String? val) {
    emit(state.copyWith(selectedMentalHealthEmergency: val));
  }

  void updateSelectedSocialSupport(String? val) {
    emit(state.copyWith(selectedsocialSupport: val));
  }

  void updateSelectedMedicationSideEffects(String? val) {
    emit(state.copyWith(selectedMedicationSideEffects: val));
  }

  void updatePreferredMentalWellnessActivities(String? val) {
    emit(state.copyWith(selectedPreferredMentalWellnessActivities: val));
  }
  // Future<String> getEyePartDescribtion({
  //   required String selectedEyePart,
  // }) async {
  //   final response = await _eyesDataEntryRepo.getEyePartDescribtion(
  //     language: AppStrings.arabicLang,
  //     userType: UserTypes.patient.name.firstLetterToUpperCase,
  //     selectedEyePart: selectedEyePart,
  //   );

  //   return response.when(
  //     success: (response) {
  //       return response;
  //     },
  //     failure: (error) {
  //       return error.errors.first;
  //     },
  //   );
  // }

  // Future<void> uploadReportImagePicked({required String imagePath}) async {
  //   emit(
  //     state.copyWith(
  //       uploadReportStatus: UploadReportRequestStatus.initial,
  //     ),
  //   );
  //   final response = await _eyesDataEntryRepo.uploadReportImage(
  //     contentType: AppStrings.contentTypeMultiPartValue,
  //     language: AppStrings.arabicLang,
  //     image: File(imagePath),
  //   );
  //   response.when(
  //     success: (response) {
  //       emit(
  //         state.copyWith(
  //           message: response.message,
  //           reportImageUploadedUrl: response.reportUrl,
  //           uploadReportStatus: UploadReportRequestStatus.success,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           message: error.errors.first,
  //           uploadReportStatus: UploadReportRequestStatus.failure,
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> postMentalIlnessDataEntryEndPoint(
    S locale,
  ) async {
    emit(
      state.copyWith(
        mentalIllnessesDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response =
        await _medicalIllnessesDataEntryRepo.postMentalIlnessDataEntryEndPoint(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      requestBody: MentalIllnessRequestBody(
        diagnosisDate: state.examinationDate!,
        mentalIllnessType: state.selectedMentalIllnessesType!,
        symptomsList: state
            .symptoms, //! check it later after delete one , is it update and after edit too
        illnessSeverity:
            state.selectedDiseaseIntensity ?? locale.no_data_entered,
        illnessDuration: state.diseaseDuration ?? locale.no_data_entered,
        hasImpactfulIncident: ImpactfulIncident(
          answer: state.hasIncidentEffect,
          incidentType: state.selectedIncidentType ?? locale.no_data_entered,
          incidentDate: state.incidentDate ?? locale.no_data_entered,
          incidentPsychologicalImpact:
              state.incidentEffect ?? locale.no_data_entered,
        ),
        hasFamilySimilarMentalIllnessCases: FamilyMentalIllness(
          answer: state.hasFamilySimilarMentalCases,
          relationship:
              state.selectedFamilyRelationType ?? locale.no_data_entered,
        ),
        selectedPsychologicalEmergencies:
            state.selectedMentalHealthEmergency ?? locale.no_data_entered,
        socialSupport: state.selectedsocialSupport ?? locale.no_data_entered,
        selectedMedicationSideEffects:
            state.selectedMedicationSideEffects ?? locale.no_data_entered,
        preferredActivitiesForImprovement:
            state.selectedPreferredMentalWellnessActivities ??
                locale.no_data_entered,
        isReceivingPsychologicalTreatment: PsychologicalTreatment(
          answer: state.isReceivingPsychologicalTreatment,
          medicationsUsed: state.medicationsUsed ?? locale.no_data_entered,
          medicationEffectOnDailyLife:
              state.medicationEffectOnLife ?? locale.no_data_entered,
          previousTherapyType:
              state.psychologicalTreatmentType ?? locale.no_data_entered,
          numberOfSessions: int.tryParse(noOfSessionsController.text) ?? 0,
          therapySatisfaction:
              state.treatmentSatisfaction ?? locale.no_data_entered,
          doctorOrSpecialist: state.psychologistName ?? locale.no_data_entered,
          hospitalOrCenter:
              state.selectedHospitalName ?? locale.no_data_entered,
          country: state.selectedCountry ?? locale.no_data_entered,
        ),
      ),
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            message: successMessage,
            mentalIllnessesDataEntryStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            mentalIllnessesDataEntryStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> submitMentalIllnessDataEnteredEdits() async {
    emit(
      state.copyWith(
        mentalIllnessesDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response =
        await _medicalIllnessesDataEntryRepo.editMentalIllnessDataEntered(
      requestBody: MentalIllnessRequestBody(
        diagnosisDate: state.examinationDate!,
        mentalIllnessType: state.selectedMentalIllnessesType!,
        symptomsList: state.symptoms,
        illnessSeverity: state.selectedDiseaseIntensity!,
        illnessDuration: state.diseaseDuration!,
        hasImpactfulIncident: ImpactfulIncident(
          answer: state.hasIncidentEffect!,
          incidentType: state.selectedIncidentType!,
          incidentDate: state.incidentDate!,
          incidentPsychologicalImpact: state.incidentEffect!,
        ),
        hasFamilySimilarMentalIllnessCases: FamilyMentalIllness(
          answer: state.hasFamilySimilarMentalCases!,
          relationship: state.selectedFamilyRelationType!,
        ),
        selectedPsychologicalEmergencies: state.selectedMentalHealthEmergency!,
        socialSupport: state.selectedsocialSupport!,
        selectedMedicationSideEffects: state.selectedMedicationSideEffects!,
        preferredActivitiesForImprovement:
            state.selectedPreferredMentalWellnessActivities!,
        isReceivingPsychologicalTreatment: PsychologicalTreatment(
          answer: state.isReceivingPsychologicalTreatment!,
          medicationsUsed: state.medicationsUsed!,
          medicationEffectOnDailyLife: state.medicationEffectOnLife!,
          previousTherapyType: state.psychologicalTreatmentType!,
          numberOfSessions: int.tryParse(noOfSessionsController.text) ?? 0,
          therapySatisfaction: state.treatmentSatisfaction!,
          doctorOrSpecialist: state.psychologistName!,
          hospitalOrCenter: state.selectedHospitalName!,
          country: state.selectedCountry!,
        ),
      ),
      id: state
          .editDecumentId, //! update it later in state varaible when load for first time comming from data view
      language: 'ar',
    );
    response.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            mentalIllnessesDataEntryStatus: RequestStatus.success,
            message: successMessage,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            mentalIllnessesDataEntryStatus: RequestStatus.failure,
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> emitCountriesData() async {
    final response = await _medicalIllnessesDataEntryRepo.getCountriesData(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (countries) {
        emit(
          state.copyWith(
            countriesNames: countries,
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

  void validateRequiredFields() {
    if (state.examinationDate == null ||
        state.selectedMentalIllnessesType == null) {
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
    noOfSessionsController.dispose();
    await clearAllAddedComplaints();
    // Dispose all controllers when cubit is closed
    for (final controller in state.symptomControllers) {
      controller.dispose();
    }

    return super.close();
  }
}
