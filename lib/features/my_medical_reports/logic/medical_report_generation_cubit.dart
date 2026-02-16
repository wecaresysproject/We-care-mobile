import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_filter_response_model.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_request_model.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_response_model.dart';
import 'package:we_care/features/my_medical_reports/data/repos/medical_report_repo.dart';

part 'medical_report_generation_state.dart';

class MedicalReportGenerationCubit extends Cubit<MedicalReportGenerationState> {
  final MedicalReportRepo _medicalReportRepo;

  MedicalReportGenerationCubit(this._medicalReportRepo)
      : super(const MedicalReportGenerationState());

  void updateBasicInfoSelection({
    bool? getAll,
    List<String>? selectedValues,
  }) {
    AppLogger.info("getAll: $getAll");
    AppLogger.info("selectedValues: $selectedValues");
    emit(
      state.copyWith(
        basicInfoGetAll: getAll,
        basicInfoSelectedValues: selectedValues,
      ),
    );
  }

  void updateVitalSignsInfoSelection({
    bool? getAll,
    List<String>? selectedValues,
  }) {
    emit(
      state.copyWith(
        vitalSignsGetAll: getAll,
        vitalSignsSelectedValues: selectedValues,
      ),
    );
  }

  void updateMedicineSelection({
    bool? getAll,
    List<String>? currentNames,
    List<String>? expiredNames,
  }) {
    AppLogger.info("updateMedicineSelection getAll: $getAll");

    emit(
      state.copyWith(
        medicineGetAll: getAll,
        medicineCurrentNames: currentNames,
        medicineExpiredNames: expiredNames,
      ),
    );
  }

  void updateChronicDiseasesSelection({
    bool? getAll,
    List<String>? selectedValues,
  }) {
    emit(
      state.copyWith(
        chronicDiseasesGetAll: getAll,
        chronicDiseasesSelectedValues: selectedValues,
      ),
    );
  }

  void updateUrgentComplaintsSelection({
    bool? getAll,
    List<String>? selectedYears,
    List<String>? selectedOrgans,
    List<String>? selectedComplaints,
    List<String>? selectedOtherComplaints,
    bool? attachImages,
  }) {
    emit(
      state.copyWith(
        urgentComplaintsGetAll: getAll,
        urgentComplaintsSelectedYears: selectedYears,
        urgentComplaintsSelectedOrgans: selectedOrgans,
        urgentComplaintsSelectedComplaints: selectedComplaints,
        urgentComplaintsSelectedOtherComplaints: selectedOtherComplaints,
        urgentComplaintsAttachImages: attachImages,
      ),
    );
    AppLogger.info(
        "urgentComplaints getAll: ${state.urgentComplaintsGetAll} , attachImages: ${state.urgentComplaintsAttachImages} , years: ${state.urgentComplaintsSelectedYears} , organs: ${state.urgentComplaintsSelectedOrgans} , complaints: ${state.urgentComplaintsSelectedComplaints} , otherComplaints: ${state.urgentComplaintsSelectedOtherComplaints}");
  }

  void updateRadiologySelection({
    bool? getAll,
    bool? attachImages,
    List<String>? selectedYears,
    List<String>? selectedRegions,
    List<String>? selectedTypes,
  }) {
    emit(
      state.copyWith(
        radiologyGetAll: getAll,
        radiologyAttachImages: attachImages,
        radiologySelectedYears: selectedYears,
        radiologySelectedRegions: selectedRegions,
        radiologySelectedTypes: selectedTypes,
      ),
    );
    AppLogger.info(
        "years: ${state.radiologySelectedYears} , regions: ${state.radiologySelectedRegions} , types: ${state.radiologySelectedTypes}");
  }

  void updateMedicalTestsSelection({
    bool? getAll,
    bool? attachImages,
    List<String>? selectedYears,
    List<String>? selectedTestGroups,
  }) {
    emit(
      state.copyWith(
        medicalTestsGetAll: getAll,
        medicalTestsSelectedYears: selectedYears,
        medicalTestsSelectedTestGroups: selectedTestGroups,
      ),
    );
  }

  void updatePrescriptionsSelection({
    bool? getAll,
    bool? attachImages,
    List<String>? selectedYears,
    List<String>? selectedSpecialties,
    List<String>? selectedDoctorNames,
  }) {
    emit(
      state.copyWith(
        prescriptionsGetAll: getAll,
        prescriptionsAttachImages: attachImages,
        prescriptionsSelectedYears: selectedYears,
        prescriptionsSelectedSpecialties: selectedSpecialties,
        prescriptionsSelectedDoctorNames: selectedDoctorNames,
      ),
    );
  }

  void updateSurgeriesSelection({
    bool? getAll,
    bool? attachReport,
    List<String>? selectedYears,
    List<String>? selectedSurgeryNames,
  }) {
    emit(
      state.copyWith(
        surgeriesGetAll: getAll,
        surgeriesAttachReport: attachReport,
        surgeriesSelectedYears: selectedYears,
        surgeriesSelectedNames: selectedSurgeryNames,
      ),
    );
  }

  void updateGeneticDiseasesSelection({
    bool? getAll,
    List<String>? familyDiseasesSelectedValues,
    List<String>? expectedGeneticDiseasesSelectedValues,
  }) {
    emit(
      state.copyWith(
        geneticDiseasesGetAll: getAll,
        geneticDiseasesSelectedValues: familyDiseasesSelectedValues,
        expectedGeneticDiseasesSelectedValues:
            expectedGeneticDiseasesSelectedValues,
      ),
    );
    AppLogger.info(
        "geneticDiseases getAll: ${state.geneticDiseasesGetAll} , familyDiseasesSelectedValues: ${state.geneticDiseasesSelectedValues} , expected: ${state.expectedGeneticDiseasesSelectedValues}");
  }

  void updateAllergiesSelection({
    bool? getAll,
    List<String>? selectedTypes,
  }) {
    emit(
      state.copyWith(
        allergiesGetAll: getAll,
        allergiesSelectedTypes: selectedTypes,
      ),
    );
  }

  void updateEyesSelection({
    bool? getAll,
    bool? attachReport,
    bool? attachMedicalTests,
    List<String>? selectedYears,
    List<String>? selectedRegions,
    List<String>? selectedSymptoms,
    List<String>? selectedMedicalProcedures,
  }) {
    emit(
      state.copyWith(
        eyesGetAll: getAll,
        eyesAttachReport: attachReport,
        attachEyeMedicalTests: attachMedicalTests,
        eyesSelectedYears: selectedYears,
        eyesSelectedRegions: selectedRegions,
        eyesSelectedSymptoms: selectedSymptoms,
        eyesSelectedMedicalProcedures: selectedMedicalProcedures,
      ),
    );
    AppLogger.info(
        "eyes getAll: ${state.eyesGetAll} , attachReport: ${state.eyesAttachReport} ,  selectedYears: ${state.eyesSelectedYears} , selectedRegions: ${state.eyesSelectedRegions} , selectedSymptoms: ${state.eyesSelectedSymptoms} , selectedMedicalProcedures: ${state.eyesSelectedMedicalProcedures}");
  }

  void updateDentalSelection({
    bool? getAll,
    bool? attachReport,
    List<String>? selectedYears,
    List<String>? selectedTeethNumbers,
    List<String>? selectedComplaints,
    List<String>? selectedMedicalProcedures,
  }) {
    emit(
      state.copyWith(
        dentalGetAll: getAll,
        dentalAttachReport: attachReport,
        dentalSelectedYears: selectedYears,
        dentalSelectedTeethNumbers: selectedTeethNumbers,
        dentalSelectedComplaints: selectedComplaints,
        dentalSelectedMedicalProcedures: selectedMedicalProcedures,
      ),
    );
  }

  void updateSmartNutritionSelection({
    bool? getAll,
    List<String>? selectedReports,
  }) {
    emit(
      state.copyWith(
        smartNutritionGetAll: getAll,
        smartNutritionSelectedReports: selectedReports,
      ),
    );
  }

  void updateSupplementsSelection({
    bool? getAll,
    List<String>? selectedYears,
    List<String>? selectedNames,
  }) {
    emit(
      state.copyWith(
        supplementsGetAll: getAll,
        supplementsSelectedYears: selectedYears,
        supplementsSelectedNames: selectedNames,
      ),
    );
  }

  void updatePhysicalActivitySelection({
    bool? getAll,
    List<String>? selectedReports,
  }) {
    emit(
      state.copyWith(
        physicalActivityGetAll: getAll,
        physicalActivitySelectedReports: selectedReports,
      ),
    );
  }

  void updateMentalDiseasesSelection({
    bool? getAll,
    List<String>? selectedTypes,
    List<String>? selectedMethods,
  }) {
    emit(
      state.copyWith(
        mentalDiseasesGetAll: getAll,
        mentalDiseasesSelectedTypes: selectedTypes,
        mentalDiseasesSelectedMethods: selectedMethods,
      ),
    );
  }

  Future<void> emitGenerateReport() async {
    final requestBody = MedicalReportRequestModel(
      selections: MedicalReportSelections(
        basicInformation: BasicInformationSelection(
          getAll: state.basicInfoGetAll,
          selectedValues: state.basicInfoSelectedValues,
        ),
        vitalSigns: VitalSignsSelectionRequestBody(
          getAll: state.vitalSignsGetAll,
          selectedValues: state.vitalSignsSelectedValues,
        ),
        medications: MedicineCategorySelectionRequestBody(
          getAll: state.medicineGetAll,
          currentMedicines: MedicineDetailsSelection(
            drugNames: state.medicineCurrentNames,
          ),
          expiredLast3Months: MedicineDetailsSelection(
            drugNames: state.medicineExpiredNames,
          ),
        ),
        chronicDiseases: ChronicDiseasesSelectionRequestBody(
          getAll: state.chronicDiseasesGetAll,
          diseases: state.chronicDiseasesSelectedValues,
        ),
        urgentComplaints: UrgentComplaintsSelectionRequestBody(
          attachImages: state.urgentComplaintsAttachImages,
          getAll: state.urgentComplaintsGetAll,
          years: state.urgentComplaintsSelectedYears,
          organs: state.urgentComplaintsSelectedOrgans,
          complaints: state.urgentComplaintsSelectedComplaints,
          otherComplaints: state.urgentComplaintsSelectedOtherComplaints,
        ),
        radiology: RadiologySelectionRequestBody(
          getAll: state.radiologyGetAll,
          attachImages: state.radiologyAttachImages,
          years: state.radiologySelectedYears,
          regions: state.radiologySelectedRegions,
          types: state.radiologySelectedTypes,
        ),
        medicalTests: MedicalTestsSelectionRequestBody(
          getAll: state.medicalTestsGetAll,
          years: state.medicalTestsSelectedYears,
          testGroups: state.medicalTestsSelectedTestGroups,
        ),
        prescriptions: PrescriptionsSelectionRequestBody(
          getAll: state.prescriptionsGetAll,
          years: state.prescriptionsSelectedYears,
          specialties: state.prescriptionsSelectedSpecialties,
          doctorNames: state.prescriptionsSelectedDoctorNames,
        ),
        surgeries: SurgeriesSelectionRequestBody(
          getAll: state.surgeriesGetAll,
          attachImages: state.surgeriesAttachReport,
          years: state.surgeriesSelectedYears, //! needs getAll here
          surgeryNames: state.surgeriesSelectedNames, //! needs getAll here
        ),
        geneticDiseases: GeneticDiseasesSelectionRequestBody(
          getAll: state.geneticDiseasesGetAll,
          familyGeneticDiseases: state.geneticDiseasesSelectedValues,
          myExpectedGeneticDiseases:
              state.expectedGeneticDiseasesSelectedValues,
        ),
        allergies: AllergiesSelectionRequestBody(
          getAll: state.allergiesGetAll,
          types: state.allergiesSelectedTypes,
        ),
        eyes: EyesSelectionRequestBody(
          getAll: state.eyesGetAll,
          attachReport: state.eyesAttachReport,
          attachMedicalTests: state.attachEyeMedicalTests,
          years: state.eyesSelectedYears,
          regions: state.eyesSelectedRegions,
          symptoms: state.eyesSelectedSymptoms,
          medicalProcedures: state.eyesSelectedMedicalProcedures,
        ),
        teeth: TeethSelectionRequestBody(
          getAll: state.dentalGetAll,
          attachReport: state.dentalAttachReport,
          years: state.dentalSelectedYears,
          teethNumbers: state.dentalSelectedTeethNumbers,
          complaints: state.dentalSelectedComplaints,
          medicalProcedures: state.dentalSelectedMedicalProcedures,
        ),
        smartNutritionalAnalyzer: SmartNutritionalAnalyzerSelectionRequestBody(
          getAll: state.smartNutritionGetAll,
          dateRanges: state.smartNutritionSelectedReports,
        ),
        supplements: SupplementsSelectionRequestBody(
          getAll: state.supplementsGetAll,
          years: state.supplementsSelectedYears,
          supplementNames: state.supplementsSelectedNames,
        ),
        sportsActivity: PhysicalActivitySelectionRequestBody(
          dateRanges: state.physicalActivitySelectedReports,
        ),
        mentalDiseases: MentalDiseasesSelectionRequestBody(
          getAll: state.mentalDiseasesGetAll,
          mentalIllnessTypes: state.mentalDiseasesSelectedTypes,
          psychologicalEmergencies: state.mentalDiseasesSelectedMethods,
        ),
      ),
    );

    emit(state.copyWith(generateReportStatus: RequestStatus.loading));

    final result = await _medicalReportRepo.fetchMedicalReportData(
      requestBody,
      AppStrings.arabicLang,
    );
    result.when(
      success: (data) {
        AppLogger.info("medical report succfulyy returned with data ");

        emit(
          state.copyWith(
            generateReportStatus: RequestStatus.success,
            medicalReportData: data,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            generateReportStatus: RequestStatus.failure,
            message: error.errors.firstOrNull ?? 'An error occurred',
          ),
        );
      },
    );
  }

  Future<void> fetchCategoryFilters(String categoryTitle, String language,
      {String userType = 'patient'}) async {
    // Avoid redundant calls
    if (state.categoryFiltersStatus[categoryTitle] == RequestStatus.success) {
      return;
    }

    final Map<String, RequestStatus> updatedStatuses =
        Map.from(state.categoryFiltersStatus);
    updatedStatuses[categoryTitle] = RequestStatus.loading;
    emit(state.copyWith(categoryFiltersStatus: updatedStatuses));

    ApiResult<MedicalReportFilterResponseModel>? result;

    // Call relevant API based on category
    if (categoryTitle == "البيانات الاساسية") {
      result = await _medicalReportRepo.getPersonalDataFilters(
        language,
        userType,
      );
    } else if (categoryTitle == "الأدوية") {
      result = await _medicalReportRepo.getMedicinesFilters(
        language,
        userType,
      );
    } else if (categoryTitle == "القياسات الحيوية") {
      result = await _medicalReportRepo.getVitalSignsFilters(
        language,
        userType,
      );
    } else if (categoryTitle == "الامراض المزمنه") {
      result = await _medicalReportRepo.getChronicDiseasesFilters(
        language,
        userType,
      );
    } else if (categoryTitle == "الشكاوى الطارئة") {
      result = await _medicalReportRepo.getUrgentComplaintsFilters(
        language,
        userType,
      );
    } else if (categoryTitle == "الأشعة") {
      result = await _medicalReportRepo.getRadiologyFilters(
        language,
        userType,
      );
    } else if (categoryTitle == "التحاليل الطبية") {
      result = await _medicalReportRepo.getMedicalTestsFilters(
        language,
        userType,
      );
    } else if (categoryTitle == "روشتة الأطباء") {
      result = await _medicalReportRepo.getPrescriptionsFilters(
        language,
        userType,
      );
    } else if (categoryTitle == "العمليات الجراحية") {
      result = await _medicalReportRepo.getSurgeriesFilters(
        language,
        userType,
      );
    } else if (categoryTitle == "الأمراض الوراثية") {
      result = await _medicalReportRepo.getGeneticDiseasesFilters(
        language,
        userType,
      );
    } else if (categoryTitle == "الحساسية") {
      result = await _medicalReportRepo.getAllergyFilters(
        language,
        userType,
      );
    } else if (categoryTitle == "العيون") {
      result = await _medicalReportRepo.getEyesFilters(
        language,
        userType,
      );
    } else if (categoryTitle == "الأسنان") {
      result = await _medicalReportRepo.getTeethFilters(
        language,
        userType,
      );
    } else if (categoryTitle == "المحلل الغذائي الذكي") {
      result = await _medicalReportRepo.getSmartNutritionFilters(
        language,
        userType,
      );
    } else if (categoryTitle == "المكملات الغذائية") {
      result = await _medicalReportRepo.getSupplementsFilters(
        language,
        userType,
      );
    } else if (categoryTitle == "النشاط الرياضي") {
      result = await _medicalReportRepo.getPhysicalActivityFilters(
        language,
        userType,
      );
    } else if (categoryTitle == "الأمراض النفسية") {
      result = await _medicalReportRepo.getMentalDiseasesFilters(
        language,
        userType,
      );
    } else {
      // Placeholder for other categories API calls
      // For now we will use dummy success for demonstration if requested
      return;
    }

    result.when(
      success: (data) {
        final Map<String, MedicalReportFilterResponseModel> updatedFilters =
            Map.from(state.categoryFilters);
        updatedFilters[categoryTitle] = data;

        final Map<String, RequestStatus> finalStatuses =
            Map.from(state.categoryFiltersStatus);
        finalStatuses[categoryTitle] = RequestStatus.success;

        emit(state.copyWith(
          categoryFilters: updatedFilters,
          categoryFiltersStatus: finalStatuses,
        ));
      },
      failure: (error) {
        final Map<String, RequestStatus> finalStatuses =
            Map.from(state.categoryFiltersStatus);
        finalStatuses[categoryTitle] = RequestStatus.failure;

        emit(state.copyWith(
          categoryFiltersStatus: finalStatuses,
          message: error.errors.firstOrNull ?? 'An error occurred',
        ));
      },
    );
  }
}
