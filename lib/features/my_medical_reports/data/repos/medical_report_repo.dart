import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/my_medical_reports/data/medical_report_api_services.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_filter_response_model.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_request_model.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_response_model.dart';

class MedicalReportRepo {
  final MedicalReportApiServices _apiServices;

  MedicalReportRepo(this._apiServices);

  Future<ApiResult<MedicalReportResponseModel>> fetchMedicalReportData(
    MedicalReportRequestModel requestBody,
    String language,
  ) async {
    try {
      final response = await _apiServices.fetchMedicalReportData(
        requestBody,
        language,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<MedicalReportFilterResponseModel>> getPersonalDataFilters(
    String language,
    String userType,
  ) async {
    try {
      final response = await _apiServices.getPersonalDataFilters(
        language,
        userType,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<MedicalReportFilterResponseModel>> getMedicinesFilters(
    String language,
    String userType,
  ) async {
    try {
      final response = await _apiServices.getMedicinesFilters(
        language,
        userType,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<MedicalReportFilterResponseModel>> getVitalSignsFilters(
    String language,
    String userType,
  ) async {
    try {
      final response = await _apiServices.getVitalSignsFilters(
        language,
        userType,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<MedicalReportFilterResponseModel>> getChronicDiseasesFilters(
    String language,
    String userType,
  ) async {
    try {
      final response = await _apiServices.getChronicDiseasesFilters(
        language,
        userType,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<MedicalReportFilterResponseModel>>
      getUrgentComplaintsFilters(
    String language,
    String userType,
  ) async {
    try {
      final response = await _apiServices.getUrgentComplaintsFilters(
        language,
        userType,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<MedicalReportFilterResponseModel>> getRadiologyFilters(
    String language,
    String userType,
  ) async {
    try {
      final response = await _apiServices.getRadiologyFilters(
        language,
        userType,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<MedicalReportFilterResponseModel>> getMedicalTestsFilters(
    String language,
    String userType,
  ) async {
    try {
      final response = await _apiServices.getMedicalTestsFilters(
        language,
        userType,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<MedicalReportFilterResponseModel>> getPrescriptionsFilters(
    String language,
    String userType,
  ) async {
    try {
      final response = await _apiServices.getPrescriptionsFilters(
        language,
        userType,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<MedicalReportFilterResponseModel>> getSurgeriesFilters(
    String language,
    String userType,
  ) async {
    try {
      final response = await _apiServices.getSurgeriesFilters(
        language,
        userType,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<MedicalReportFilterResponseModel>> getGeneticDiseasesFilters(
    String language,
    String userType,
  ) async {
    try {
      final response = await _apiServices.getGeneticDiseasesFilters(
        language,
        userType,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<MedicalReportFilterResponseModel>> getAllergyFilters(
    String language,
    String userType,
  ) async {
    try {
      final response = await _apiServices.getAllergyFilters(
        language,
        userType,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<MedicalReportFilterResponseModel>> getEyesFilters(
    String language,
    String userType,
  ) async {
    try {
      final response = await _apiServices.getEyesFilters(
        language,
        userType,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<MedicalReportFilterResponseModel>> getTeethFilters(
    String language,
    String userType,
  ) async {
    try {
      final response = await _apiServices.getTeethFilters(
        language,
        userType,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<MedicalReportFilterResponseModel>> getSmartNutritionFilters(
    String language,
    String userType,
  ) async {
    try {
      final response = await _apiServices.getSmartNutritionFilters(
        language,
        userType,
      );
      return ApiResult.success(
          MedicalReportFilterResponseModel.fromJson(response["data"]));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}

final dummyMedicalReportResponse = MedicalReportResponseModel(
  success: true,
  message: "تم جلب التقرير الطبي بنجاح",
  data: MedicalReportData(
    basicInformation: [
      BasicInformationData(
        label: "الاسم",
        value: "أشرف السيد",
      ),
      BasicInformationData(
        label: "تاريخ الميلاد",
        value: "2015-12-16",
      ),
      BasicInformationData(
        label: "فصيلة الدم",
        value: "A+",
      ),
      BasicInformationData(
        label: "الدولة",
        value: "مصر",
      ),
    ],
    vitalSigns: [
      VitalSignGroupModel(
        categoryName: "الوزن",
        reading: [
          VitalReadingModel(
            min: "75",
            max: null,
            date: "2025-10-11",
          ),
          VitalReadingModel(
            min: "76",
            max: null,
            date: "2025-10-13",
          ),
          VitalReadingModel(
            min: "77",
            max: null,
            date: "2025-10-15",
          ),
        ],
      ),
      VitalSignGroupModel(
        categoryName: "الضغط",
        reading: [
          VitalReadingModel(
            min: "129",
            max: "80",
            date: "2025-11-14",
          ),
          VitalReadingModel(
            min: "150",
            max: "90",
            date: "2025-11-16",
          ),
        ],
      ),
      VitalSignGroupModel(
        categoryName: "سكر صائم",
        reading: [
          VitalReadingModel(
            min: "110",
            max: null,
            date: "2025-10-15",
          ),
          VitalReadingModel(
            min: "125",
            max: null,
            date: "2025-11-16",
          ),
        ],
      ),
    ],
  ),
);
