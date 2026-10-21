import 'package:flutter/foundation.dart';
import 'package:we_care/core/models/medical_module_enum.dart';
import 'package:we_care/features/allowed_care_access/data/models/module_permission_dto.dart';

class CareContextManager {
  CareContextManager._();

  static final ValueNotifier<CareContext?> activeContextNotifier =
      ValueNotifier<CareContext?>(null);

  static CareContext? get activeContext => activeContextNotifier.value;

  static bool get isCareModeActive => activeContextNotifier.value != null;

  static List<ModulePermissionDto>? get currentActiveProfilePermissions =>
      activeContextNotifier.value?.modulePermissions;

  /// A doctor is browsing a patient's file through a booking.
  static bool get isDoctorAccess =>
      activeContextNotifier.value?.source == CareAccessSource.doctorBooking;

  /// Add, edit and delete actions must be hidden.
  static bool get isReadOnly => isDoctorAccess;

  static void enter({
    required String accessId,
    required String patientId,
    required String patientName,
    required List<ModulePermissionDto> modulePermissions,
    CareAccessSource source = CareAccessSource.family,
    DateTime? expiresAt,
    void Function(String? reason)? onClose,
  }) {
    activeContextNotifier.value = CareContext(
      accessId: accessId,
      patientId: patientId,
      patientName: patientName,
      modulePermissions: modulePermissions,
      source: source,
      expiresAt: expiresAt,
      onClose: onClose,
    );
  }

  static void exit() {
    activeContextNotifier.value = null;
  }

  static bool hasModuleAccessForViewMedicalFilesCategory(
      MedicalModule? moduleIdentifier) {
    if (isCareModeActive) {
      if (moduleIdentifier == null) return false;
      final permissions = currentActiveProfilePermissions ?? [];
      final matches =
          permissions.where((p) => p.moduleNameIdentifier == moduleIdentifier);
      final modulePerm = matches.isEmpty ? null : matches.first;
      final bool hasAccess = modulePerm != null &&
          modulePerm.isEnabledModule &&
          (modulePerm.permission == 'FULL_ACCESS' ||
              modulePerm.permission == 'VIEW_ONLY');

      return hasAccess;
    }
    return true; //* default user account access
  }

  static bool hasModuleAccessForDataEntryMedicalFilesCategory(
      MedicalModule? moduleIdentifier) {
    if (isCareModeActive) {
      if (moduleIdentifier == null) return false;
      final permissions = currentActiveProfilePermissions ?? [];
      final matches =
          permissions.where((p) => p.moduleNameIdentifier == moduleIdentifier);
      final modulePerm = matches.isEmpty ? null : matches.first;
      final bool hasAccess = modulePerm != null &&
          modulePerm.isEnabledModule &&
          (modulePerm.permission == 'FULL_ACCESS');
      if (hasAccess) {
        return true;
      } else {
        return false;
      }
    }
    return true; //* default user account access
  }

  static bool isCurrentPatient(String patientId) {
    return activeContextNotifier.value?.patientId == patientId;
  }
}

enum CareAccessSource {
  /// Family/delegated access from the "allowed care access" feature.
  family,

  /// A doctor's read-only access granted by the patient when booking.
  doctorBooking,
}

class CareContext {
  final String accessId;
  final String patientId;
  final String patientName;
  final List<ModulePermissionDto> modulePermissions;
  final CareAccessSource source;

  /// When the access ends — only set for [CareAccessSource.doctorBooking].
  final DateTime? expiresAt;

  /// Leaves the file and returns to the screen that opened it. [reason] is
  /// shown to the user when access was cut (expired / revoked).
  final void Function(String? reason)? onClose;

  const CareContext({
    required this.accessId,
    required this.patientId,
    required this.patientName,
    required this.modulePermissions,
    this.source = CareAccessSource.family,
    this.expiresAt,
    this.onClose,
  });
}
