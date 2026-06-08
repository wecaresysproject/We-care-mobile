class CareContextManager {
  CareContextManager._();

  static CareContext? _activeContext;

  static CareContext? get activeContext => _activeContext;

  static bool get isCareModeActive => _activeContext != null;

  static void enter({
    required String accessId,
    required String patientId,
    required String patientName,
    required CarePermission permission,
  }) {
    _activeContext = CareContext(
      accessId: accessId,
      patientId: patientId,
      patientName: patientName,
      permission: permission,
    );
  }

  static void exit() {
    _activeContext = null;
  }

  static bool isCurrentPatient(String patientId) {
    return _activeContext?.patientId == patientId;
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
