import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';

import 'package:we_care/features/medicine/data/models/get_all_user_medicines_responce_model.dart';
import 'package:we_care/features/medicine/data/models/get_medicines_filters_response_model.dart';
import 'package:we_care/features/medicine/medicines_services.dart';

class MedicinesViewRepo {
  MedicinesViewRepo(
    MedicinesServices medicinesServices,
  ) : _medicinesServices = medicinesServices;

  final MedicinesServices _medicinesServices;

  Future<ApiResult<GetAllUserMedicinesResponseModel>> getAllMedicines({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _medicinesServices.getAllMedicines(
        language,
        userType,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<GetAllUserMedicinesResponseModel>> getFilteredMedicines({
    required String language,
    required String userType,
    int? year,
    String? medicineName,
  }) async {
    try {
      final response = await _medicinesServices.getFilteredMedicines(
        language,
        userType,
        year,
        medicineName,
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResult<GetMedicinesFiltersResponseModel>> getMedicinesFilters({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _medicinesServices.getMedicinesFilters(
        language,
        userType,
      );
      return ApiResult.success(
        GetMedicinesFiltersResponseModel.fromJson(response["data"]),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }

    // Future<ApiResult<List<DetailedComplaintModel>>>
    //     getFilteredEmergencyComplaints({
    //   String? year,
    //   String? placeOfComplaint,
    // }) async {
    //   try {
    //     final response = await _emergencyComplaintsServices.getFilteredData(
    //         year, placeOfComplaint);
    //     return ApiResult.success(
    //       (response["data"] as List)
    //           .map<DetailedComplaintModel>(
    //               (e) => DetailedComplaintModel.fromJson(e))
    //           .toList(),
    //     );
    //   } catch (e) {
    //     return ApiResult.failure(ApiErrorHandler.handle(e));
    //   }
    // }

    // Future<ApiResult<List<String>>> getYearsFilter({
    //   required String language,
    // }) async {
    //   try {
    //     final response =
    //         await _emergencyComplaintsServices.getYearsFilter(language);

    //     // Convert List<dynamic> to List<String>
    //     final List<String> yearsList =
    //         (response["data"] as List<dynamic>).map<String>((dynamic item) {
    //       return item as String; // Ensure each item is a String
    //     }).toList();

    //     return ApiResult.success(yearsList);
    //   } catch (e) {
    //     return ApiResult.failure(ApiErrorHandler.handle(e));
    //   }
    // }

    // Future<ApiResult<List<String>>> getPlaceOfComplaint({
    //   required String language,
    // }) async {
    //   try {
    //     final response =
    //         await _emergencyComplaintsServices.getPlaceOfComplaint(language);

    //     final List<String> placeOfComplaintList =
    //         (response["data"] as List<dynamic>).map<String>((dynamic item) {
    //       return item as String;
    //     }).toList();

    //     return ApiResult.success(placeOfComplaintList);
    //   } catch (e) {
    //     return ApiResult.failure(ApiErrorHandler.handle(e));
    //   }
    // }

    // Future<ApiResult<DetailedComplaintModel>> getEmergencyComplaintById({
    //   required String id,
    //   required String language,
    // }) async {
    //   try {
    //     final response = await _emergencyComplaintsServices
    //         .getEmergencyComplaintById(id, language);
    //     return ApiResult.success(
    //         DetailedComplaintModel.fromJson(response["data"]));
    //   } catch (e) {
    //     return ApiResult.failure(ApiErrorHandler.handle(e));
    //   }
    // }

    // Future<ApiResult<String>> deleteEmergencyComplaintById({
    //   required String id,
    // }) async {
    //   try {
    //     final response =
    //         await _emergencyComplaintsServices.deleteEmergencyComplaintById(id);
    //     return ApiResult.success(response["message"]);
    //   } catch (e) {
    //     return ApiResult.failure(ApiErrorHandler.handle(e));
    //   }
    // }
  }
}
