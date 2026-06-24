import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'incoming_care_access_requests_response.g.dart';

@JsonSerializable(explicitToJson: true)
class IncomingCareAccessRequestsResponse extends Equatable {
  final int pendingRequestsCount;
  final List<IncomingCareAccessRequestModel> requests;

  const IncomingCareAccessRequestsResponse({
    required this.pendingRequestsCount,
    required this.requests,
  });

  factory IncomingCareAccessRequestsResponse.fromJson(
          Map<String, dynamic> json) =>
      _$IncomingCareAccessRequestsResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$IncomingCareAccessRequestsResponseToJson(this);

  @override
  List<Object?> get props => [pendingRequestsCount, requests];
}

@JsonSerializable(explicitToJson: true)
class IncomingCareAccessRequestModel extends Equatable {
  final String requestId;
  final String? requesterUserId;
  final String? requesterName;
  final List<ModulePermissionModel>? modulePermissions;
  final String? requestedAt;
  final String? timeAgo;

  const IncomingCareAccessRequestModel({
    required this.requestId,
    this.requesterUserId,
    this.requesterName,
    this.modulePermissions,
    this.requestedAt,
    this.timeAgo,
  });

  factory IncomingCareAccessRequestModel.fromJson(Map<String, dynamic> json) =>
      _$IncomingCareAccessRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$IncomingCareAccessRequestModelToJson(this);

  @override
  List<Object?> get props => [
        requestId,
        requesterUserId,
        requesterName,
        modulePermissions,
        requestedAt,
        timeAgo,
      ];
}

@JsonSerializable()
class ModulePermissionModel extends Equatable {
  final String moduleName;
  final String permission;
  final bool isEnabledModule;

  const ModulePermissionModel({
    required this.moduleName,
    required this.permission,
    required this.isEnabledModule,
  });

  factory ModulePermissionModel.fromJson(Map<String, dynamic> json) =>
      _$ModulePermissionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModulePermissionModelToJson(this);

  @override
  List<Object?> get props => [
        moduleName,
        permission,
        isEnabledModule,
      ];
}
