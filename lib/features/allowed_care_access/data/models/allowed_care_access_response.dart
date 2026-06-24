import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/allowed_care_access/data/models/module_permission_dto.dart';

part 'allowed_care_access_response.g.dart';

@JsonSerializable(explicitToJson: true)
class AllowedCareAccessResponse extends Equatable {
  final int pendingRequests;
  final List<GrantedProfileModel> profiles;

  const AllowedCareAccessResponse({
    required this.pendingRequests,
    required this.profiles,
  });

  factory AllowedCareAccessResponse.fromJson(Map<String, dynamic> json) =>
      _$AllowedCareAccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AllowedCareAccessResponseToJson(this);

  @override
  List<Object?> get props => [pendingRequests, profiles];
}

@JsonSerializable(explicitToJson: true)
class GrantedProfileModel extends Equatable {
  final String? requestId;
  final String accessId;
  final String patientId;
  final String patientName;
  final String? personalPhotoUrl;
  final String relation;
  final List<ModulePermissionDto> modulePermissions;
  final String joinedAt;

  const GrantedProfileModel({
    this.requestId,
    required this.accessId,
    required this.patientId,
    required this.patientName,
    this.personalPhotoUrl,
    required this.relation,
    required this.modulePermissions,
    required this.joinedAt,
  });

  factory GrantedProfileModel.fromJson(Map<String, dynamic> json) =>
      _$GrantedProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$GrantedProfileModelToJson(this);

  @override
  List<Object?> get props => [
        requestId,
        accessId,
        patientId,
        patientName,
        personalPhotoUrl,
        relation,
        modulePermissions,
        joinedAt,
      ];
}
