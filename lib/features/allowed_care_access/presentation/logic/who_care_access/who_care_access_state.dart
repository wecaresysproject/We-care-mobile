import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/allowed_care_access/data/models/module_permission_dto.dart';
import 'package:we_care/features/allowed_care_access/data/models/who_can_access_response.dart';

@immutable
class WhoCareAccessState extends Equatable {
  final Map<String, ModulePermissionDto> draftModulePermissions;
  final RequestStatus savePermissionsStatus;
  final String savePermissionsMessage;
  final RequestStatus getWhoCanAccessStatus;
  final List<WhoCanAccessData> whoCanAccessList;
  final String getWhoCanAccessMessage;
  final String selectedRequestId;
  final RequestStatus revokeAccessStatus;
  final String revokeAccessMessage;

  const WhoCareAccessState({
    this.draftModulePermissions = const {},
    this.savePermissionsStatus = RequestStatus.initial,
    this.savePermissionsMessage = '',
    this.getWhoCanAccessStatus = RequestStatus.initial,
    this.whoCanAccessList = const [],
    this.getWhoCanAccessMessage = '',
    this.selectedRequestId = '',
    this.revokeAccessStatus = RequestStatus.initial,
    this.revokeAccessMessage = '',
  });

  const WhoCareAccessState.initialState() : this();

  WhoCareAccessState copyWith({
    Map<String, ModulePermissionDto>? draftModulePermissions,
    RequestStatus? savePermissionsStatus,
    String? savePermissionsMessage,
    RequestStatus? getWhoCanAccessStatus,
    List<WhoCanAccessData>? whoCanAccessList,
    String? getWhoCanAccessMessage,
    String? selectedRequestId,
    RequestStatus? revokeAccessStatus,
    String? revokeAccessMessage,
  }) {
    return WhoCareAccessState(
      draftModulePermissions: draftModulePermissions ?? this.draftModulePermissions,
      savePermissionsStatus: savePermissionsStatus ?? this.savePermissionsStatus,
      savePermissionsMessage: savePermissionsMessage ?? this.savePermissionsMessage,
      getWhoCanAccessStatus: getWhoCanAccessStatus ?? this.getWhoCanAccessStatus,
      whoCanAccessList: whoCanAccessList ?? this.whoCanAccessList,
      getWhoCanAccessMessage: getWhoCanAccessMessage ?? this.getWhoCanAccessMessage,
      selectedRequestId: selectedRequestId ?? this.selectedRequestId,
      revokeAccessStatus: revokeAccessStatus ?? this.revokeAccessStatus,
      revokeAccessMessage: revokeAccessMessage ?? this.revokeAccessMessage,
    );
  }

  @override
  List<Object?> get props => [
        draftModulePermissions,
        savePermissionsStatus,
        savePermissionsMessage,
        getWhoCanAccessStatus,
        whoCanAccessList,
        getWhoCanAccessMessage,
        selectedRequestId,
        revokeAccessStatus,
        revokeAccessMessage,
      ];
}
