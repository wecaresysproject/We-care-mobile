import 'package:we_care/core/models/medical_module_enum.dart';
import 'package:we_care/features/allowed_care_access/data/models/module_permission_dto.dart';

/// What the patient allowed the doctor to see when booking: which modules,
/// and until when.
class BookingPatientAccessModel {
  const BookingPatientAccessModel({
    required this.patientId,
    required this.patientName,
    required this.expiresAt,
    required this.modulePermissions,
  });

  factory BookingPatientAccessModel.fromJson(Map<String, dynamic> json) {
    final permissions = json['modulePermissions'] as List<dynamic>? ?? [];
    return BookingPatientAccessModel(
      patientId: json['patientId']?.toString() ?? '',
      patientName: json['patientName'] as String? ?? '',
      expiresAt: DateTime.tryParse(json['accessExpiresAt']?.toString() ?? ''),
      modulePermissions: [
        for (final item in permissions)
          _permissionFromJson(item as Map<String, dynamic>),
      ],
    );
  }

  /// `moduleName` carries the [MedicalModule] name, the same value the
  /// booking request sends in `dataAccessModules`.
  static ModulePermissionDto _permissionFromJson(Map<String, dynamic> json) {
    final moduleName = json['moduleName']?.toString() ?? '';
    final matches = MedicalModule.values.where((m) => m.name == moduleName);
    return ModulePermissionDto(
      moduleName: moduleName,
      // Doctors are always read-only, whatever the server sends.
      permission: 'VIEW_ONLY',
      isEnabledModule: json['isEnabledModule'] as bool? ?? true,
      moduleNameIdentifier: matches.isEmpty ? null : matches.first,
    );
  }

  final String patientId;
  final String patientName;
  final DateTime? expiresAt;
  final List<ModulePermissionDto> modulePermissions;

  /// No end time means the patient picked no duration, so no access —
  /// the same rule the bookings row uses.
  bool get isExpired =>
      expiresAt == null || !DateTime.now().isBefore(expiresAt!);

  bool get hasAnyModule => modulePermissions.any(
        (p) => p.isEnabledModule && p.moduleNameIdentifier != null,
      );
}
