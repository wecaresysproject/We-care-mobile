import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/emergency_complaints/data/models/emergency_complain_request_body.dart';
import 'package:we_care/features/medicine/data/models/basic_medicine_info_model.dart';

import '../../emergency_complaints_services.dart';

class EmergencyComplaintsDataEntryRepo {
  final EmergencyComplaintsServices _emergencyComplaintsServices;

  EmergencyComplaintsDataEntryRepo(this._emergencyComplaintsServices);

  Future<ApiResult<List<String>>> getAllPlacesOfComplaints(
      {required String language}) async {
    try {
      final response =
          await _emergencyComplaintsServices.getAllPlacesOfComplaints(language);
      final complaints =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(complaints);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllComplaintsRelevantToBodyPartName({
    required String bodyPartName,
    required String language,
    required String mainArea,
  }) async {
    try {
      final response = await _emergencyComplaintsServices
          .getAllComplaintsRelevantToBodyPartName(
        mainArea,
        bodyPartName,
        language,
      );
      final complaints =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(complaints);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> postEmergencyDataEntry(
      {required EmergencyComplainRequestBody requestBody,
      required String language}) async {
    try {
      final response =
          await _emergencyComplaintsServices.postEmergencyDataEntry(
        requestBody,
        language,
      );
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> editSpecifcEmergencyDocumentDataDetails({
    required EmergencyComplainRequestBody requestBody,
    required String language,
    required String documentId,
  }) async {
    try {
      final response = await _emergencyComplaintsServices
          .editSpecifcEmergencyDocumentDataDetails(
        requestBody,
        language,
        documentId,
      );
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllMedicinesNames({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _emergencyComplaintsServices.getAllMedicinesNames(
        language,
        userType,
      );
      final medicineNames = (response['data'] as List)
          .map((e) => MedicineBasicInfoModel.fromJson(e).tradeName)
          .toList();

      return ApiResult.success(medicineNames);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>>
      getAllOrganOrPartSymptomsRelativeToMainRegion({
    required String mainRegion,
    required String language,
  }) async {
    try {
      final response = await _emergencyComplaintsServices
          .getAllOrganOrPartSymptomsRelativeToMainRegion(mainRegion, language);
      final complaints =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(complaints);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
