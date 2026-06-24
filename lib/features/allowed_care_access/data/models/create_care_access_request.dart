import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/allowed_care_access/data/models/module_permission_dto.dart';

part 'create_care_access_request.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateCareAccessRequest extends Equatable {
  final String targetUserId;
  final String relation;
  final List<ModulePermissionDto> modulePermissions;

  const CreateCareAccessRequest({
    required this.targetUserId,
    required this.relation,
    required this.modulePermissions,
  });

  factory CreateCareAccessRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCareAccessRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCareAccessRequestToJson(this);

  @override
  List<Object?> get props => [
        targetUserId,
        relation,
        modulePermissions,
      ];
}
