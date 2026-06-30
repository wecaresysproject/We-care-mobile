import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/allowed_care_access/data/models/module_permission_dto.dart';

part 'who_can_access_response.g.dart';

@JsonSerializable(explicitToJson: true)
class WhoCanAccessResponse extends Equatable {
  final List<WhoCanAccessData>? data;
  final int? pendingRequests;

  const WhoCanAccessResponse({
    this.data,
    this.pendingRequests,
  });

  factory WhoCanAccessResponse.fromJson(Map<String, dynamic> json) =>
      _$WhoCanAccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WhoCanAccessResponseToJson(this);

  @override
  List<Object?> get props => [data, pendingRequests];
}

@JsonSerializable(explicitToJson: true)
class WhoCanAccessData extends Equatable {
  final String? accessId;
  final String? patientId;
  final String? patientName;
  final String? personalPhotoUrl;
  final String? relation;
  final String? joinedAt;
  final List<ModulePermissionDto>? modulePermissions;

  const WhoCanAccessData({
    this.accessId,
    this.patientId,
    this.patientName,
    this.personalPhotoUrl,
    this.relation,
    this.joinedAt,
    this.modulePermissions,
  });

  factory WhoCanAccessData.fromJson(Map<String, dynamic> json) =>
      _$WhoCanAccessDataFromJson(json);

  Map<String, dynamic> toJson() => _$WhoCanAccessDataToJson(this);

  @override
  List<Object?> get props => [
        accessId,
        patientId,
        patientName,
        personalPhotoUrl,
        relation,
        joinedAt,
        modulePermissions,
      ];
}
