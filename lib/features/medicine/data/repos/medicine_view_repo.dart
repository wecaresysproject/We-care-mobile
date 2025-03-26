import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/emergency_complaints/data/models/get_single_complaint_response_model.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_services.dart';

class EmergencyComplaintsViewRepo {
  EmergencyComplaintsViewRepo(
      EmergencyComplaintsServices emergencyComplaintsServices)
      : _emergencyComplaintsServices = emergencyComplaintsServices;

  final EmergencyComplaintsServices _emergencyComplaintsServices;

  Future<ApiResult<List<DetailedComplaintModel>>> getAllEmergencyComplaints({
    required String language,
  }) async {
    try {
      final response = await _emergencyComplaintsServices
          .getAllEmergencyComplaints(language);
      return ApiResult.success(
        (response["complaints"] as List)
            .map<DetailedComplaintModel>(
                (e) => DetailedComplaintModel.fromJson(e))
            .toList(),
      );
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResult<List<DetailedComplaintModel>>>
      getFilteredEmergencyComplaints({
    String? year,
    String? placeOfComplaint,
  }) async {
    try {
      final response = await _emergencyComplaintsServices.getFilteredData(
          year, placeOfComplaint);
      return ApiResult.success(
        (response["data"] as List)
            .map<DetailedComplaintModel>(
                (e) => DetailedComplaintModel.fromJson(e))
            .toList(),
      );
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResult<List<String>>> getYearsFilter({
    required String language,
  }) async {
    try {
      final response =
          await _emergencyComplaintsServices.getYearsFilter(language);

      // Convert List<dynamic> to List<String>
      final List<String> yearsList =
          (response["data"] as List<dynamic>).map<String>((dynamic item) {
        return item as String; // Ensure each item is a String
      }).toList();

      return ApiResult.success(yearsList);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResult<List<String>>> getPlaceOfComplaint({
    required String language,
  }) async {
    try {
      final response =
          await _emergencyComplaintsServices.getPlaceOfComplaint(language);

      final List<String> placeOfComplaintList =
          (response["data"] as List<dynamic>).map<String>((dynamic item) {
        return item as String;
      }).toList();

      return ApiResult.success(placeOfComplaintList);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResult<DetailedComplaintModel>> getEmergencyComplaintById({
    required String id,
    required String language,
  }) async {
    try {
      final response = await _emergencyComplaintsServices
          .getEmergencyComplaintById(id, language);
      return ApiResult.success(
          DetailedComplaintModel.fromJson(response["data"]));
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResult<String>> deleteEmergencyComplaintById({
    required String id,
  }) async {
    try {
      final response =
          await _emergencyComplaintsServices.deleteEmergencyComplaintById(id);
      return ApiResult.success(response["message"]);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }
}
