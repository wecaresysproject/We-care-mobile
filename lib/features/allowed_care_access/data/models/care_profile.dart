import 'package:equatable/equatable.dart';

enum PermissionType {
  fullAccess,
  viewOnly,
}

class CareProfile extends Equatable {
  final String id;
  final String name;
  final String relation;
  final PermissionType permissionType;
  final String addedAtLabel;

  const CareProfile({
    required this.id,
    required this.name,
    required this.relation,
    required this.permissionType,
    required this.addedAtLabel,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        relation,
        permissionType,
        addedAtLabel,
      ];
}
