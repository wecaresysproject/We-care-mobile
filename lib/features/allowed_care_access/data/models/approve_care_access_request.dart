import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/allowed_care_access/data/models/module_permission_dto.dart';

part 'approve_care_access_request.g.dart';

@JsonSerializable(explicitToJson: true)
class ApproveCareAccessRequest {
  final String requestId;
  @JsonKey(name: 'ModulePermissions')
  final List<ModulePermissionDto> modulePermissions;

  ApproveCareAccessRequest({
    required this.requestId,
    required this.modulePermissions,
  });

  factory ApproveCareAccessRequest.fromJson(Map<String, dynamic> json) =>
      _$ApproveCareAccessRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ApproveCareAccessRequestToJson(this);
}
