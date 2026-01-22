import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
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
    emit(
      state.copyWith(
        basicInfoGetAll: getAll,
        basicInfoSelectedValues: selectedValues,
      ),
    );
  }

  void updateMedicineSelection({
    bool? getAll,
    List<String>? currentNames,
    List<String>? expiredNames,
  }) {
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

  Future<void> emitGenerateReport(String language) async {
    final requestBody = MedicalReportRequestModel(
      selections: MedicalReportSelections(
        basicInformation: BasicInformationSelection(
          getAll: state.basicInfoGetAll,
          selectedValues: state.basicInfoSelectedValues,
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
      ),
    );

    emit(state.copyWith(status: RequestStatus.loading));

    final result = await _medicalReportRepo.fetchMedicalReportData(
      requestBody,
      language,
    );

    result.when(
      success: (data) {
        AppLogger.info(
            "Medical report data: ${data.data.basicInformation!.entries.first.value}");
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
