import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/allowed_care_access/access_management_api_constants.dart';
import 'package:we_care/features/allowed_care_access/data/models/allowed_care_access_response.dart';
import 'package:we_care/features/allowed_care_access/data/models/approve_care_access_request.dart';
import 'package:we_care/features/allowed_care_access/data/models/care_access_request_details_response.dart';
import 'package:we_care/features/allowed_care_access/data/models/create_care_access_request.dart';
import 'package:we_care/features/allowed_care_access/data/models/create_care_access_response.dart';
import 'package:we_care/features/allowed_care_access/data/models/incoming_care_access_requests_response.dart';
import 'package:we_care/features/allowed_care_access/data/models/search_phone_number_response.dart';
import 'package:we_care/features/allowed_care_access/data/models/update_access_permissions_request.dart';
import 'package:we_care/features/allowed_care_access/data/models/who_can_access_response.dart';

part 'access_management_service.g.dart';

@RestApi(baseUrl: AccessManagementApiConstants.baseUrl)
abstract class AccessManagementService {
  factory AccessManagementService(Dio dio, {String baseUrl}) =
      _AccessManagementService;
  @GET(AccessManagementApiConstants.searchPhoneNumber)
  Future<SearchPhoneNumberResponse> searchPhoneNumber(
    @Query('PhoneNumber') String phoneNumber,
  );

  @POST(AccessManagementApiConstants.createCareAccessRequest)
  Future<CreateCareAccessResponse> createCareAccessRequest(
    @Body() CreateCareAccessRequest body,
  );

  @GET('AccessManagement/incoming-requests')
  Future<IncomingCareAccessRequestsResponse> getIncomingCareAccessRequests();

  @GET('AccessManagement/granted')
  Future<AllowedCareAccessResponse> getAllowedCareAccessList();

  @GET('AccessManagement/request-details')
  Future<CareAccessRequestDetailsResponse> getCareAccessRequestDetails(
    @Query('requestId') String requestId,
  );

  @POST('AccessManagement/approve')
  Future<dynamic> approveCareAccessRequest(
    @Body() ApproveCareAccessRequest request,
  );

  @POST('AccessManagement/reject')
  Future<dynamic> rejectCareAccessRequest(
    @Body() String requestId,
  );

  @PUT('AccessManagement/update-access-permissions')
  Future<dynamic> updateAccessPermissions(
    @Body() UpdateAccessPermissionsRequest request,
  );

  @DELETE('AccessManagement/revoke-access')
  Future<dynamic> revokeAccess(
    @Query('accessId') String accessId,
  );

  @GET('AccessManagement/who-can-access')
  Future<WhoCanAccessResponse> getWhoCanAccess();
}
