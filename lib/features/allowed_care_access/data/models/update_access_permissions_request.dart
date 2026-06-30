import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/allowed_care_access/data/models/module_permission_dto.dart';

part 'update_access_permissions_request.g.dart';

@JsonSerializable(explicitToJson: true)
class UpdateAccessPermissionsRequest extends Equatable {
  final String accessId;
  final List<ModulePermissionDto> modulePermissions;

  const UpdateAccessPermissionsRequest({
    required this.accessId,
    required this.modulePermissions,
  });

  factory UpdateAccessPermissionsRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateAccessPermissionsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateAccessPermissionsRequestToJson(this);

  @override
  List<Object?> get props => [accessId, modulePermissions];
}
