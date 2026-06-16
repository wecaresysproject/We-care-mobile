import 'package:we_care/core/networking/access_management_service.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/allowed_care_access/data/models/allowed_care_access_response.dart';
import 'package:we_care/features/allowed_care_access/data/models/approve_care_access_request.dart';
import 'package:we_care/features/allowed_care_access/data/models/care_access_request_details_response.dart';
import 'package:we_care/features/allowed_care_access/data/models/create_care_access_request.dart';
import 'package:we_care/features/allowed_care_access/data/models/incoming_care_access_requests_response.dart';
import 'package:we_care/features/allowed_care_access/data/models/search_phone_number_response.dart';

class AccessManagementRepository {
  final AccessManagementService _accessManagementService;

  AccessManagementRepository(this._accessManagementService);

  Future<ApiResult<SearchPhoneNumberResponse>> searchPhoneNumber(
      String phoneNumber) async {
    try {
      final response =
          await _accessManagementService.searchPhoneNumber(phoneNumber);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> createCareAccessRequest(
      CreateCareAccessRequest request) async {
    try {
      final response =
          await _accessManagementService.createCareAccessRequest(request);
      return ApiResult.success(response.message);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<IncomingCareAccessRequestsResponse>>
      getIncomingCareAccessRequests() async {
    try {
      final response =
          await _accessManagementService.getIncomingCareAccessRequests();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<AllowedCareAccessResponse>>
      getAllowedCareAccessList() async {
    try {
      final response =
          await _accessManagementService.getAllowedCareAccessList();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<CareAccessRequestDetailsResponse>>
      getCareAccessRequestDetails(String requestId) async {
    try {
      final response =
          await _accessManagementService.getCareAccessRequestDetails(requestId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> approveCareAccessRequest(
      ApproveCareAccessRequest request) async {
    try {
      final response =
          await _accessManagementService.approveCareAccessRequest(request);
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> rejectCareAccessRequest(
      String requestID) async {
    try {
      final response =
          await _accessManagementService.rejectCareAccessRequest(requestID);
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
