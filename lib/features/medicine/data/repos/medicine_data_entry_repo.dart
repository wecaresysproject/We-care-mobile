import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/medicine/medicines_services.dart';

class MedicinesDataEntryRepo {
  final MedicinesServices _medicinesServices;

  MedicinesDataEntryRepo(this._medicinesServices);

  Future<ApiResult<List<String>>> getAllPlacesOfComplaints(
      {required String language}) async {
    try {
      final response =
          await _medicinesServices.getAllPlacesOfComplaints(language);
      final complaints =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(complaints);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllComplaintsRelevantToBodyPartName({
    required String bodyPartName,
  }) async {
    try {
      final response = await _medicinesServices
          .getAllComplaintsRelevantToBodyPartName(bodyPartName);
      final complaints =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(complaints);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  // Future<ApiResult<String>> postEmergencyDataEntry(
  //     {required EmergencyComplainRequestBody requestBody,
  //     required String language}) async {
  //   try {
  //     final response =
  //         await _emergencyComplaintsServices.postEmergencyDataEntry(
  //       requestBody,
  //       language,
  //     );
  //     return ApiResult.success(response['message']);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<String>> editSpecifcEmergencyDocumentDataDetails({
  //   required EmergencyComplainRequestBody requestBody,
  //   required String language,
  //   required String documentId,
  // }) async {
  //   try {
  //     final response = await _emergencyComplaintsServices
  //         .editSpecifcEmergencyDocumentDataDetails(
  //       requestBody,
  //       language,
  //       documentId,
  //     );
  //     return ApiResult.success(response['message']);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }
}
