import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/allowed_care_access/data/models/approve_care_access_request.dart';
import 'package:we_care/features/allowed_care_access/data/models/create_care_access_request.dart';
import 'package:we_care/features/allowed_care_access/data/models/module_permission_dto.dart';
import 'package:we_care/features/allowed_care_access/data/models/search_phone_number_response.dart';
import 'package:we_care/features/allowed_care_access/data/repositories/access_management_repository.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_state.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_categories_data.dart';

class AccessManagementCubit extends Cubit<AccessManagementState>
    with SafeEmitMixin {
  final AccessManagementRepository _accessManagementRepository;

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController relationController = TextEditingController();

  AccessManagementCubit(this._accessManagementRepository)
      : super(const AccessManagementState.initialState()) {
    _initializePermissions();
  }

  void _initializePermissions() {
    final updatedPermissions = <String, ModulePermissionDto>{};
    final titles = categoriesView.map((e) => e.title).toList();
    for (final title in titles) {
      updatedPermissions[title] = ModulePermissionDto(
        moduleName: title,
        permission: 'FULL_ACCESS',
        isEnabledModule: true,
      );
    }
    safeEmit(state.copyWith(modulePermissions: updatedPermissions));
  }

  Future<void> searchPhoneNumber() async {
    final phoneNumber = phoneNumberController.text.trim();
    //* add +2 to the beginning of the phone number if it doesn't start with it
    final String formattedNumber =
        phoneNumber.startsWith('+2') ? phoneNumber : '+2$phoneNumber';
    if (phoneNumber.isEmpty) return;
    safeEmit(state.copyWith(searchStatus: RequestStatus.loading));

    final result =
        await _accessManagementRepository.searchPhoneNumber(formattedNumber);

    result.when(
      success: (data) {
        safeEmit(
          state.copyWith(
            searchStatus: RequestStatus.success,
            message: data.message,
            searchResults: data.data.users,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            searchStatus: RequestStatus.failure,
            message: error.errors.join('\n'),
          ),
        );
      },
    );
  }

  void updateSelectedUser(SearchPhoneNumberUser user) {
    safeEmit(state.copyWith(selectedUser: user));
  }

  void updateSelectedPermission(String permission) {
    safeEmit(state.copyWith(selectedPermission: permission));
  }

  void updateModulePermission(String moduleTitle, String permission) {
    final updatedPermissions =
        Map<String, ModulePermissionDto>.from(state.modulePermissions);
    final current = updatedPermissions[moduleTitle];
    if (current != null) {
      updatedPermissions[moduleTitle] = ModulePermissionDto(
        moduleName: current.moduleName,
        permission: permission,
        isEnabledModule: current.isEnabledModule,
      );
    } else {
      updatedPermissions[moduleTitle] = ModulePermissionDto(
        moduleName: moduleTitle,
        permission: permission,
        isEnabledModule: true,
      );
    }
    safeEmit(state.copyWith(modulePermissions: updatedPermissions));
  }

  void toggleModuleEnabled(String moduleTitle, bool isEnabled) {
    final updatedPermissions =
        Map<String, ModulePermissionDto>.from(state.modulePermissions);
    final current = updatedPermissions[moduleTitle];
    if (current != null) {
      updatedPermissions[moduleTitle] = ModulePermissionDto(
        moduleName: current.moduleName,
        permission: current.permission,
        isEnabledModule: isEnabled,
      );
    } else {
      updatedPermissions[moduleTitle] = ModulePermissionDto(
        moduleName: moduleTitle,
        permission: 'VIEW_ONLY',
        isEnabledModule: isEnabled,
      );
    }
    safeEmit(state.copyWith(modulePermissions: updatedPermissions));
  }

  void setAllModulesPermission(String permission, List<String> moduleTitles) {
    final updatedPermissions =
        Map<String, ModulePermissionDto>.from(state.modulePermissions);
    for (final title in moduleTitles) {
      final current = updatedPermissions[title];
      updatedPermissions[title] = ModulePermissionDto(
        moduleName: title,
        permission: permission,
        isEnabledModule: current?.isEnabledModule ?? true,
      );
    }
    safeEmit(state.copyWith(modulePermissions: updatedPermissions));
  }

  void initDraftPermissions() {
    safeEmit(state.copyWith(
        draftModulePermissions: Map.from(state.modulePermissions)));
  }

  void updateDraftModulePermission(String moduleTitle, String permission) {
    final updatedPermissions =
        Map<String, ModulePermissionDto>.from(state.draftModulePermissions);
    final current = updatedPermissions[moduleTitle];
    if (current != null) {
      updatedPermissions[moduleTitle] = ModulePermissionDto(
        moduleName: current.moduleName,
        permission: permission,
        isEnabledModule: current.isEnabledModule,
      );
    } else {
      updatedPermissions[moduleTitle] = ModulePermissionDto(
        moduleName: moduleTitle,
        permission: permission,
        isEnabledModule: true,
      );
    }
    safeEmit(state.copyWith(draftModulePermissions: updatedPermissions));
  }

  void toggleDraftModuleEnabled(String moduleTitle, bool isEnabled) {
    final updatedPermissions =
        Map<String, ModulePermissionDto>.from(state.draftModulePermissions);
    final current = updatedPermissions[moduleTitle];
    if (current != null) {
      updatedPermissions[moduleTitle] = ModulePermissionDto(
        moduleName: current.moduleName,
        permission: current.permission,
        isEnabledModule: isEnabled,
      );
    } else {
      updatedPermissions[moduleTitle] = ModulePermissionDto(
        moduleName: moduleTitle,
        permission: 'VIEW_ONLY',
        isEnabledModule: isEnabled,
      );
    }
    safeEmit(state.copyWith(draftModulePermissions: updatedPermissions));
  }

  void setAllDraftModulesPermission(
      String permission, List<String> moduleTitles) {
    final updatedPermissions =
        Map<String, ModulePermissionDto>.from(state.draftModulePermissions);
    for (final title in moduleTitles) {
      final current = updatedPermissions[title];
      updatedPermissions[title] = ModulePermissionDto(
        moduleName: title,
        permission: permission,
        isEnabledModule: current?.isEnabledModule ?? true,
      );
    }
    safeEmit(state.copyWith(draftModulePermissions: updatedPermissions));
  }

  void saveDraftPermissions() {
    safeEmit(state.copyWith(
        modulePermissions: Map.from(state.draftModulePermissions)));
  }

  Future<void> createCareAccessRequest() async {
    final relation = relationController.text.trim();
    if (relation.isEmpty) {
      safeEmit(state.copyWith(
        createRequestStatus: RequestStatus.failure,
        createRequestMessage: 'يرجى إدخال صلة القرابة',
      ));
      return;
    }

    if (state.selectedUser == null) {
      safeEmit(state.copyWith(
        createRequestStatus: RequestStatus.failure,
        createRequestMessage: 'يرجى اختيار مستخدم أولاً',
      ));
      return;
    }

    safeEmit(state.copyWith(createRequestStatus: RequestStatus.loading));

    final modulePermissionsList = state.modulePermissions.values.toList();

    final request = CreateCareAccessRequest(
      targetUserId: state.selectedUser!.userId.toString(),
      relation: relation,
      modulePermissions: modulePermissionsList,
    );

    final result =
        await _accessManagementRepository.createCareAccessRequest(request);

    result.when(
      success: (message) {
        safeEmit(
          state.copyWith(
            createRequestStatus: RequestStatus.success,
            createRequestMessage: message,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            createRequestStatus: RequestStatus.failure,
            createRequestMessage: error.errors.join('\n'),
          ),
        );
      },
    );
  }

  Future<void> getIncomingCareAccessRequests() async {
    safeEmit(state.copyWith(incomingRequestsStatus: RequestStatus.loading));

    final result =
        await _accessManagementRepository.getIncomingCareAccessRequests();

    result.when(
      success: (data) {
        safeEmit(
          state.copyWith(
            incomingRequestsStatus: RequestStatus.success,
            incomingRequests: data,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            incomingRequestsStatus: RequestStatus.failure,
            incomingRequestsMessage: error.errors.join('\n'),
          ),
        );
      },
    );
  }

  Future<void> getAllowedCareAccessList() async {
    safeEmit(state.copyWith(allowedCareAccessStatus: RequestStatus.loading));

    final result = await _accessManagementRepository.getAllowedCareAccessList();

    result.when(
      success: (data) {
        safeEmit(
          state.copyWith(
            allowedCareAccessStatus: RequestStatus.success,
            allowedCareAccessList: data,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            allowedCareAccessStatus: RequestStatus.failure,
            allowedCareAccessMessage: error.errors.join('\n'),
          ),
        );
      },
    );
  }

  Future<void> getCareAccessRequestDetails(String requestId) async {
    safeEmit(state.copyWith(requestDetailsStatus: RequestStatus.loading));

    final result = await _accessManagementRepository
        .getCareAccessRequestDetails(requestId);

    result.when(
      success: (data) {
        final Map<String, ModulePermissionDto> permissionsMap = {};
        for (final module in data.modulePermissions) {
          if (module.moduleName.isNotEmpty) {
            permissionsMap[module.moduleName] = ModulePermissionDto(
              moduleName: module.moduleName,
              permission: module.permission,
              isEnabledModule: module.isEnabledModule,
            );
          }
        }

        safeEmit(
          state.copyWith(
            requestDetailsStatus: RequestStatus.success,
            requestDetails: data,
            modulePermissions:
                permissionsMap.isNotEmpty ? permissionsMap : null,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            requestDetailsStatus: RequestStatus.failure,
            requestDetailsMessage: error.errors.join('\n'),
          ),
        );
      },
    );
  }

  Future<void> approveCareAccessRequest(String requestId) async {
    safeEmit(state.copyWith(approveRequestStatus: RequestStatus.loading));

    final modulePermissionsList = state.modulePermissions.values.toList();

    final request = ApproveCareAccessRequest(
      requestId: requestId,
      modulePermissions: modulePermissionsList,
    );

    final result =
        await _accessManagementRepository.approveCareAccessRequest(request);

    result.when(
      success: (message) {
        safeEmit(
          state.copyWith(
            approveRequestStatus: RequestStatus.success,
            approveRequestMessage: message,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            approveRequestStatus: RequestStatus.failure,
            approveRequestMessage: error.errors.join('\n'),
          ),
        );
      },
    );
  }

  Future<void> rejectCareAccessRequest(String requestId) async {
    safeEmit(state.copyWith(rejectRequestStatus: RequestStatus.loading));

    final result =
        await _accessManagementRepository.rejectCareAccessRequest(requestId);

    result.when(
      success: (message) {
        safeEmit(
          state.copyWith(
            rejectRequestStatus: RequestStatus.success,
            rejectRequestMessage: message,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            rejectRequestStatus: RequestStatus.failure,
            rejectRequestMessage: error.errors.join('\n'),
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    phoneNumberController.dispose();
    relationController.dispose();
    return super.close();
  }
}
