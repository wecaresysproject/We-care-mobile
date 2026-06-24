import 'package:flutter/foundation.dart';
import 'package:we_care/features/allowed_care_access/data/models/module_permission_dto.dart';

class CareContextManager {
  CareContextManager._();

  static final ValueNotifier<CareContext?> activeContextNotifier =
      ValueNotifier<CareContext?>(null);

  static CareContext? get activeContext => activeContextNotifier.value;

  static bool get isCareModeActive => activeContextNotifier.value != null;

  static List<ModulePermissionDto>? get currentActiveProfilePermissions =>
      activeContextNotifier.value?.modulePermissions;

  static void enter({
    required String accessId,
    required String patientId,
    required String patientName,
    required List<ModulePermissionDto> modulePermissions,
  }) {
    activeContextNotifier.value = CareContext(
      accessId: accessId,
      patientId: patientId,
      patientName: patientName,
      modulePermissions: modulePermissions,
    );
  }

  static void exit() {
    activeContextNotifier.value = null;
  }

  static bool isCurrentPatient(String patientId) {
    return activeContextNotifier.value?.patientId == patientId;
  }
}

class CareContext {
  final String accessId;
  final String patientId;
  final String patientName;
  final List<ModulePermissionDto> modulePermissions;

  const CareContext({
    required this.accessId,
    required this.patientId,
    required this.patientName,
    required this.modulePermissions,
  });
}
