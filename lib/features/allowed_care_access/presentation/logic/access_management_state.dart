import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/allowed_care_access/data/models/allowed_care_access_response.dart';
import 'package:we_care/features/allowed_care_access/data/models/care_access_request_details_response.dart';
import 'package:we_care/features/allowed_care_access/data/models/incoming_care_access_requests_response.dart';
import 'package:we_care/features/allowed_care_access/data/models/module_permission_dto.dart';
import 'package:we_care/features/allowed_care_access/data/models/search_phone_number_response.dart';

@immutable
class AccessManagementState extends Equatable {
  final RequestStatus searchStatus;
  final String message;
  final List<SearchPhoneNumberUser> searchResults;
  final SearchPhoneNumberUser? selectedUser;
  final RequestStatus createRequestStatus;
  final String createRequestMessage;
  final String selectedPermission;
  final RequestStatus incomingRequestsStatus;
  final String incomingRequestsMessage;
  final IncomingCareAccessRequestsResponse? incomingRequests;
  final RequestStatus allowedCareAccessStatus;
  final String allowedCareAccessMessage;
  final AllowedCareAccessResponse? allowedCareAccessList;
  final RequestStatus requestDetailsStatus;
  final String requestDetailsMessage;
  final CareAccessRequestDetailsResponse? requestDetails;
  final RequestStatus approveRequestStatus;
  final String approveRequestMessage;
  final RequestStatus rejectRequestStatus;
  final String rejectRequestMessage;
  final Map<String, ModulePermissionDto> modulePermissions;
  final Map<String, ModulePermissionDto> draftModulePermissions;

  const AccessManagementState({
    this.searchStatus = RequestStatus.initial,
    this.message = '',
    this.searchResults = const [],
    this.selectedUser,
    this.createRequestStatus = RequestStatus.initial,
    this.createRequestMessage = '',
    this.selectedPermission = 'FULL_ACCESS',
    this.incomingRequestsStatus = RequestStatus.initial,
    this.incomingRequestsMessage = '',
    this.incomingRequests,
    this.allowedCareAccessStatus = RequestStatus.initial,
    this.allowedCareAccessMessage = '',
    this.allowedCareAccessList,
    this.requestDetailsStatus = RequestStatus.initial,
    this.requestDetailsMessage = '',
    this.requestDetails,
    this.approveRequestStatus = RequestStatus.initial,
    this.approveRequestMessage = '',
    this.rejectRequestStatus = RequestStatus.initial,
    this.rejectRequestMessage = '',
    this.modulePermissions = const {},
    this.draftModulePermissions = const {},
  });

  const AccessManagementState.initialState() : this();

  AccessManagementState copyWith({
    RequestStatus? searchStatus,
    String? message,
    List<SearchPhoneNumberUser>? searchResults,
    SearchPhoneNumberUser? selectedUser,
    RequestStatus? createRequestStatus,
    String? createRequestMessage,
    String? selectedPermission,
    RequestStatus? incomingRequestsStatus,
    String? incomingRequestsMessage,
    IncomingCareAccessRequestsResponse? incomingRequests,
    RequestStatus? allowedCareAccessStatus,
    String? allowedCareAccessMessage,
    AllowedCareAccessResponse? allowedCareAccessList,
    RequestStatus? requestDetailsStatus,
    String? requestDetailsMessage,
    CareAccessRequestDetailsResponse? requestDetails,
    RequestStatus? approveRequestStatus,
    String? approveRequestMessage,
    RequestStatus? rejectRequestStatus,
    String? rejectRequestMessage,
    Map<String, ModulePermissionDto>? modulePermissions,
    Map<String, ModulePermissionDto>? draftModulePermissions,
  }) {
    return AccessManagementState(
      searchStatus: searchStatus ?? this.searchStatus,
      message: message ?? this.message,
      searchResults: searchResults ?? this.searchResults,
      selectedUser: selectedUser ?? this.selectedUser,
      createRequestStatus: createRequestStatus ?? this.createRequestStatus,
      createRequestMessage: createRequestMessage ?? this.createRequestMessage,
      selectedPermission: selectedPermission ?? this.selectedPermission,
      incomingRequestsStatus:
          incomingRequestsStatus ?? this.incomingRequestsStatus,
      incomingRequestsMessage:
          incomingRequestsMessage ?? this.incomingRequestsMessage,
      incomingRequests: incomingRequests ?? this.incomingRequests,
      allowedCareAccessStatus:
          allowedCareAccessStatus ?? this.allowedCareAccessStatus,
      allowedCareAccessMessage:
          allowedCareAccessMessage ?? this.allowedCareAccessMessage,
      allowedCareAccessList:
          allowedCareAccessList ?? this.allowedCareAccessList,
      requestDetailsStatus: requestDetailsStatus ?? this.requestDetailsStatus,
      requestDetailsMessage:
          requestDetailsMessage ?? this.requestDetailsMessage,
      requestDetails: requestDetails ?? this.requestDetails,
      approveRequestStatus: approveRequestStatus ?? this.approveRequestStatus,
      approveRequestMessage:
          approveRequestMessage ?? this.approveRequestMessage,
      rejectRequestStatus: rejectRequestStatus ?? this.rejectRequestStatus,
      rejectRequestMessage: rejectRequestMessage ?? this.rejectRequestMessage,
      modulePermissions: modulePermissions ?? this.modulePermissions,
      draftModulePermissions: draftModulePermissions ?? this.draftModulePermissions,
    );
  }

  @override
  List<Object?> get props => [
        searchStatus,
        message,
        searchResults,
        selectedUser,
        createRequestStatus,
        createRequestMessage,
        selectedPermission,
        incomingRequestsStatus,
        incomingRequestsMessage,
        incomingRequests,
        allowedCareAccessStatus,
        allowedCareAccessMessage,
        allowedCareAccessList,
        requestDetailsStatus,
        requestDetailsMessage,
        requestDetails,
        approveRequestStatus,
        approveRequestMessage,
        rejectRequestStatus,
        rejectRequestMessage,
        modulePermissions,
        draftModulePermissions,
      ];
}
