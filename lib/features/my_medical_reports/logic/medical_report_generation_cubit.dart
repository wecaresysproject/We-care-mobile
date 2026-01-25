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
  }) {
    emit(
      state.copyWith(
        urgentComplaintsGetAll: getAll,
        urgentComplaintsSelectedYears: selectedYears,
        urgentComplaintsSelectedOrgans: selectedOrgans,
        urgentComplaintsSelectedComplaints: selectedComplaints,
      ),
    );
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
        medicalTestsAttachImages: attachImages,
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

  Future<void> emitGenerateReport() async {
    final requestBody = MedicalReportRequestModel(
      selections: MedicalReportSelections(
        basicInformation: BasicInformationSelection(
          getAll: state.basicInfoGetAll,
          selectedValues: state.basicInfoSelectedValues,
        ),
        // vitalSigns: VitalSignsSelectionRequestBody(
        //   getAll: state.vitalSignsGetAll,
        //   selectedValues: state.vitalSignsSelectedValues,
        // ),
        // medications: MedicineCategorySelectionRequestBody(
        //   getAll: state.medicineGetAll,
        //   currentMedicines: MedicineDetailsSelection(
        //     drugNames: state.medicineCurrentNames,
        //   ),
        //   expiredLast3Months: MedicineDetailsSelection(
        //     drugNames: state.medicineExpiredNames,
        //   ),
        // ),
        // chronicDiseases: ChronicDiseasesSelectionRequestBody(
        //   getAll: state.chronicDiseasesGetAll,
        //   diseases: state.chronicDiseasesSelectedValues,
        // ),
        // urgentComplaints: UrgentComplaintsSelectionRequestBody(
        //   getAll: state.urgentComplaintsGetAll,
        //   years: state.urgentComplaintsSelectedYears,
        //   organs: state.urgentComplaintsSelectedOrgans,
        //   complaints: state.urgentComplaintsSelectedComplaints,
        // ),
        // radiology: RadiologySelectionRequestBody(
        //   getAll: state.radiologyGetAll, //! need check later
        //   attachImages: state.radiologyAttachImages,
        //   years: state.radiologySelectedYears,
        //   regions: state.radiologySelectedRegions,
        //   types: state.radiologySelectedTypes,
        // ),
        // medicalTests: MedicalTestsSelectionRequestBody(
        //   getAll: state.medicalTestsGetAll,
        //   attachImages: state.medicalTestsAttachImages,
        //   years: state.medicalTestsSelectedYears,
        //   testGroups: state.medicalTestsSelectedTestGroups,
        // ),
        // prescriptions: PrescriptionsSelectionRequestBody(
        //   getAll: state.prescriptionsGetAll,
        //   attachImages: state.prescriptionsAttachImages,
        //   years: state.prescriptionsSelectedYears,
        //   specialties: state.prescriptionsSelectedSpecialties,
        //   doctorNames: state.prescriptionsSelectedDoctorNames,
        // ),
      ),
    );

    emit(state.copyWith(status: RequestStatus.loading));

    final result = await _medicalReportRepo.fetchMedicalReportData(
      requestBody,
      AppStrings.arabicLang,
    );

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            status: RequestStatus.success,
            medicalReportData: data,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            status: RequestStatus.failure,
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
