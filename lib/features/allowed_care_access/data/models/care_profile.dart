import 'package:equatable/equatable.dart';
import 'package:we_care/features/allowed_care_access/data/models/module_permission_dto.dart';

enum PermissionType {
  fullAccess,
  viewOnly,
}

class CareProfile extends Equatable {
  final String id;
  final String patientId;
  final String name;
  final String personalPhotoUrl;
  final String relation;
  final String addedAtLabel;
  final List<ModulePermissionDto> modulePermissions;

  const CareProfile({
    required this.id,
    required this.patientId,
    required this.name,
    required this.personalPhotoUrl,
    required this.relation,
    required this.addedAtLabel,
    required this.modulePermissions,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        patientId,
        personalPhotoUrl,
        relation,
        addedAtLabel,
        modulePermissions,
      ];
}
