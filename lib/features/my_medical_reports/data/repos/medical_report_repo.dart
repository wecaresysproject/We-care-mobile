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
      // final response = await _apiServices.fetchMedicalReportData(
      //   requestBody,
      //   language,
      // );
      return ApiResult.success(dummyMedicalReportResponse);
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

  final dummyMedicalReportResponse = MedicalReportResponseModel(
    status: 200,
    message: 'تم جلب البيانات الأساسية بنجاح',
    data: MedicalReportData(
      basicInformation: {
        'fullName': BasicInformationData(
          label: 'الاسم الكامل',
          value: 'أحمد محمد علي',
        ),
        'birthDate': BasicInformationData(
          label: 'تاريخ الميلاد',
          value: '1990-05-15',
        ),
        'gender': BasicInformationData(
          label: 'النوع',
          value: 'ذكر',
        ),
        'bloodType': BasicInformationData(
          label: 'فصيلة الدم',
          value: 'O+',
        ),
        'country': BasicInformationData(
          label: 'الدولة',
          value: 'مصر',
        ),
        'city': BasicInformationData(
          label: 'المدينة',
          value: 'القاهرة',
        ),
        'disabilityType': BasicInformationData(
          label: 'نوع العجز الجسدي',
          value: null,
        ),
        'medicalInsurance': BasicInformationData(
          label: 'التأمين الطبي',
          value: {
            'provider': 'التعاونية للتأمين',
            'policyNumber': 'POL-998877',
            'expiryDate': '2026-12-31',
          },
        ),
      },
    ),
  );
}
