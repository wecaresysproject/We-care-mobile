import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/core/models/medical_module_enum.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_filter_response_model.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_request_model.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_response_model.dart';
import 'package:we_care/features/my_medical_reports/data/repos/medical_report_repo.dart';

part 'medical_report_generation_state.dart';

class MedicalReportGenerationCubit extends Cubit<MedicalReportGenerationState> {
  final MedicalReportRepo _medicalReportRepo;
  final AppSharedRepo sharedRepo;

  MedicalReportGenerationCubit(this._medicalReportRepo, this.sharedRepo)
      : super(const MedicalReportGenerationState());

  Future<void> emitModuleGuidanceData() async {
    final response = await sharedRepo.getModuleGuidance(
      WeCareMedicalModules.myMedicalReports.name,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            moduleGuidanceData: response,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            moduleGuidanceData: null,
          ),
        );
      },
    );
  }

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

  void updateVaccinationsSelection({
    bool? getAll,
    List<String>? selectedYears,
  }) {
    emit(
      state.copyWith(
        vaccinationsGetAll: getAll,
        vaccinationsSelectedYears: selectedYears,
      ),
    );
    AppLogger.info(
        "[التطعيمات] getAll: ${state.vaccinationsGetAll} | السنة: ${state.vaccinationsSelectedYears}");
  }

  void updateRiskyBehavioursSelection({
    bool? getAll,
    List<String>? selectedTypes,
  }) {
    emit(
      state.copyWith(
        riskyBehavioursGetAll: getAll,
        riskyBehavioursSelectedTypes: selectedTypes,
      ),
    );
    AppLogger.info(
        "[السلوكيات الخطرة] getAll: ${state.riskyBehavioursGetAll} | النوع: ${state.riskyBehavioursSelectedTypes}");
  }

  /// جودة الحياة: مفيش فلاتر — بس مفعّل / مش مفعّل (checkbox التصنيف).
  void updateQualityOfLifeSelection({bool? getAll}) {
    emit(
      state.copyWith(
        qualityOfLifeGetAll: getAll,
      ),
    );
    AppLogger.info(
        "[جودة الحياة] getAll (active): ${state.qualityOfLifeGetAll}");
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
          getAll: state.physicalActivityGetAll,
          dateRanges: state.physicalActivitySelectedReports,
        ),
        mentalDiseases: MentalDiseasesSelectionRequestBody(
          getAll: state.mentalDiseasesGetAll,
          mentalIllnessTypes: state.mentalDiseasesSelectedTypes,
          psychologicalEmergencies: state.mentalDiseasesSelectedMethods,
        ),
        qualityOfLife: QualityOfLifeSelectionRequestBody(
          getAll: state.qualityOfLifeGetAll,
        ),
        riskyBehaviours: RiskyBehavioursSelectionRequestBody(
          getAll: state.riskyBehavioursGetAll,
          section: state.riskyBehavioursSelectedTypes,
        ),
        vaccinations: VaccinationsSelectionRequestBody(
          getAll: state.vaccinationsGetAll,
          years: state.vaccinationsSelectedYears,
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

    // نحوّل عنوان التصنيف لـ enum (مصدر واحد للحقيقة) بدل مقارنة نصوص ثابتة،
    // وبنحدد دالة الـ API المناسبة. لو مفيش موديول أو مفيش API ليه → null.
    final module = MedicalModuleExtension.fromString(categoryTitle);
    final request = module == null
        ? null
        : _filtersRequestForModule(module, language, userType);

    // مفيش API لهذا التصنيف — نوقف الـ loading بدل ما يفضل معلّق للأبد
    if (request == null) {
      AppLogger.warning(
          "[FILTERS] '$categoryTitle' (module: $module) → مفيش API فلاتر، هيعتمد على الـ checkbox بس");
      _updateCategoryStatus(categoryTitle, RequestStatus.success);
      return;
    }

    AppLogger.debug(
        "[FILTERS] جاري جلب فلاتر '$categoryTitle' (module: $module)...");
    _updateCategoryStatus(categoryTitle, RequestStatus.loading);

    final result = await request;

    result.when(
      success: (data) {
        // نطبع كل قسم وفلتر بقيمه — عشان نعرف المفاتيح المتوقعة في المزامنة
        for (final section in data.filterSections ?? []) {
          for (final filter in section.filters) {
            AppLogger.info(
                "[FILTERS] '$categoryTitle' → فلتر '${filter.title}' | القيم: ${filter.values}");
          }
        }
        AppLogger.info(
            "[FILTERS] ✅ '$categoryTitle' اتحمّلت | selectionType: ${data.selectionType}");

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
        AppLogger.error(
            "[FILTERS] ❌ فشل تحميل فلاتر '$categoryTitle': ${error.errors.firstOrNull}");
        _updateCategoryStatus(
          categoryTitle,
          RequestStatus.failure,
          message: error.errors.firstOrNull ?? 'An error occurred',
        );
      },
    );
  }

  /// يرجّع دالة جلب الفلاتر المناسبة للموديول، أو null لو مفيش API ليه.
  /// الربط بيتم عن طريق الـ enum مش نصوص ثابتة، فأي تغيير في مسمّى الموديول
  /// بيتبع تلقائيًا من غير ما يكسر المطابقة.
  Future<ApiResult<MedicalReportFilterResponseModel>>? _filtersRequestForModule(
    MedicalModule module,
    String language,
    String userType,
  ) {
    switch (module) {
      case MedicalModule.basicInformation:
        return _medicalReportRepo.getPersonalDataFilters(language, userType);
      case MedicalModule.medications:
        return _medicalReportRepo.getMedicinesFilters(language, userType);
      case MedicalModule.vitalSigns:
        return _medicalReportRepo.getVitalSignsFilters(language, userType);
      case MedicalModule.chronicDiseases:
        return _medicalReportRepo.getChronicDiseasesFilters(language, userType);
      case MedicalModule.urgentComplaints:
        return _medicalReportRepo.getUrgentComplaintsFilters(
            language, userType);
      case MedicalModule.radiology:
        return _medicalReportRepo.getRadiologyFilters(language, userType);
      case MedicalModule.medicalTests:
        return _medicalReportRepo.getMedicalTestsFilters(language, userType);
      case MedicalModule.doctorsPrescriptions:
        return _medicalReportRepo.getPrescriptionsFilters(language, userType);
      case MedicalModule.surgeries:
        return _medicalReportRepo.getSurgeriesFilters(language, userType);
      case MedicalModule.geneticDiseases:
        return _medicalReportRepo.getGeneticDiseasesFilters(language, userType);
      case MedicalModule.allergies:
        return _medicalReportRepo.getAllergyFilters(language, userType);
      case MedicalModule.eyes:
        return _medicalReportRepo.getEyesFilters(language, userType);
      case MedicalModule.dental:
        return _medicalReportRepo.getTeethFilters(language, userType);
      case MedicalModule.smartNutritionalAnalyzer:
        return _medicalReportRepo.getSmartNutritionFilters(language, userType);
      case MedicalModule.supplements:
        return _medicalReportRepo.getSupplementsFilters(language, userType);
      case MedicalModule.sportsActivity:
        return _medicalReportRepo.getPhysicalActivityFilters(
            language, userType);
      case MedicalModule.mentalHealth:
        return _medicalReportRepo.getMentalDiseasesFilters(language, userType);
      case MedicalModule.vaccinations:
        return _medicalReportRepo.getVaccinationsFilters(language, userType);
      case MedicalModule.riskyBehaviors:
        return _medicalReportRepo.getRiskyBehavioursFilters(
            language, userType);
      default:
        // موديولات من غير API فلاتر (زي جودة الحياة — checkbox بس)
        return null;
    }
  }

  /// helper لتحديث حالة تصنيف واحد (loading/success/failure) من غير تكرار.
  void _updateCategoryStatus(
    String categoryTitle,
    RequestStatus status, {
    String? message,
  }) {
    final Map<String, RequestStatus> updatedStatuses =
        Map.from(state.categoryFiltersStatus);
    updatedStatuses[categoryTitle] = status;
    emit(state.copyWith(
      categoryFiltersStatus: updatedStatuses,
      message: message,
    ));
  }
}
