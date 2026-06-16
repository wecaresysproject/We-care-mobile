import 'package:flutter/foundation.dart';

class CareContextManager {
  CareContextManager._();

  static final ValueNotifier<CareContext?> activeContextNotifier =
      ValueNotifier<CareContext?>(null);

  static CareContext? get activeContext => activeContextNotifier.value;

  static bool get isCareModeActive => activeContextNotifier.value != null;

  static CarePermission? get currentActiveProfilePermission =>
      activeContextNotifier.value?.permission;

  static void enter({
    required String accessId,
    required String patientId,
    required String patientName,
    required CarePermission permission,
  }) {
    activeContextNotifier.value = CareContext(
      accessId: accessId,
      patientId: patientId,
      patientName: patientName,
      permission: permission,
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
  final CarePermission permission;

  const CareContext({
    required this.accessId,
    required this.patientId,
    required this.patientName,
    required this.permission,
  });
}

enum CarePermission {
  fullAccess,
  viewOnly,
}
