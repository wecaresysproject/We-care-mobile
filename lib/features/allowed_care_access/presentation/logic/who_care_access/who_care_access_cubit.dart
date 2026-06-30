import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/models/medical_module_enum.dart';
import 'package:we_care/features/allowed_care_access/data/models/module_permission_dto.dart';
import 'package:we_care/features/allowed_care_access/data/models/update_access_permissions_request.dart';
import 'package:we_care/features/allowed_care_access/data/repositories/access_management_repository.dart';

import 'who_care_access_state.dart';

class WhoCareAccessCubit extends Cubit<WhoCareAccessState> {
  final AccessManagementRepository _repository;

  WhoCareAccessCubit(this._repository)
      : super(const WhoCareAccessState.initialState());

  void initPermissions(
      {required String requestId,
      required Map<String, ModulePermissionDto> permissions}) {
    emit(state.copyWith(
      selectedRequestId: requestId,
      draftModulePermissions: Map.from(permissions),
    ));
  }

  void toggleDraftModuleEnabled(String moduleName, bool isEnabled) {
    final Map<String, ModulePermissionDto> draftPermissions =
        Map.from(state.draftModulePermissions);

    final currentDto = draftPermissions[moduleName] ??
        ModulePermissionDto(
          moduleName: moduleName,
          permission: 'VIEW_ONLY',
          isEnabledModule: false,
          moduleNameIdentifier: MedicalModuleExtension.fromString(moduleName),
        );

    draftPermissions[moduleName] = ModulePermissionDto(
      moduleName: moduleName,
      permission: currentDto.permission,
      isEnabledModule: isEnabled,
      moduleNameIdentifier: currentDto.moduleNameIdentifier,
    );

    emit(state.copyWith(draftModulePermissions: draftPermissions));
  }

  void updateDraftModulePermission(String moduleName, String permissionLevel) {
    final Map<String, ModulePermissionDto> draftPermissions =
        Map.from(state.draftModulePermissions);

    final currentDto = draftPermissions[moduleName] ??
        ModulePermissionDto(
          moduleName: moduleName,
          permission: 'VIEW_ONLY',
          isEnabledModule: false,
          moduleNameIdentifier: MedicalModuleExtension.fromString(moduleName),
        );

    draftPermissions[moduleName] = ModulePermissionDto(
      moduleName: moduleName,
      permission: permissionLevel,
      isEnabledModule: currentDto.isEnabledModule,
      moduleNameIdentifier: currentDto.moduleNameIdentifier,
    );

    emit(state.copyWith(draftModulePermissions: draftPermissions));
  }

  void setAllDraftModulesPermission(
      String permissionLevel, List<String> availableModules) {
    final Map<String, ModulePermissionDto> draftPermissions =
        Map.from(state.draftModulePermissions);

    for (var moduleName in availableModules) {
      final currentDto = draftPermissions[moduleName];
      // Only modify enabled modules
      if (currentDto != null && currentDto.isEnabledModule) {
        draftPermissions[moduleName] = ModulePermissionDto(
          moduleName: moduleName,
          permission: permissionLevel,
          isEnabledModule: true,
          moduleNameIdentifier: currentDto.moduleNameIdentifier,
        );
      }
    }

    emit(state.copyWith(draftModulePermissions: draftPermissions));
  }

  Future<void> updateAccessPermissions() async {
    emit(state.copyWith(savePermissionsStatus: RequestStatus.loading));

    final request = UpdateAccessPermissionsRequest(
      accessId: state.selectedRequestId,
      modulePermissions: state.draftModulePermissions.values.toList(),
    );

    final result = await _repository.updateAccessPermissions(request);

    result.when(
      success: (message) {
        emit(state.copyWith(
          savePermissionsStatus: RequestStatus.success,
          savePermissionsMessage: message,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          savePermissionsStatus: RequestStatus.failure,
          savePermissionsMessage: error.errors.first,
        ));
      },
    );
  }

  Future<void> revokeAccess(String accessId) async {
    emit(state.copyWith(revokeAccessStatus: RequestStatus.loading));

    final result = await _repository.revokeAccess(accessId);

    result.when(
      success: (message) {
        emit(state.copyWith(
          revokeAccessStatus: RequestStatus.success,
          revokeAccessMessage: message,
        ));
        // Refresh the list after successful revocation
        getWhoCanAccess();
      },
      failure: (error) {
        emit(state.copyWith(
          revokeAccessStatus: RequestStatus.failure,
          revokeAccessMessage: error.errors.first,
        ));
      },
    );
  }

  Future<void> getWhoCanAccess() async {
    emit(state.copyWith(getWhoCanAccessStatus: RequestStatus.loading));
    final result = await _repository.getWhoCanAccess();
    result.when(
      success: (response) {
        emit(state.copyWith(
          getWhoCanAccessStatus: RequestStatus.success,
          whoCanAccessList: response.data ?? [],
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          getWhoCanAccessStatus: RequestStatus.failure,
          getWhoCanAccessMessage: error.errors.first ?? 'حدث خطأ غير متوقع',
        ));
      },
    );
  }
}
