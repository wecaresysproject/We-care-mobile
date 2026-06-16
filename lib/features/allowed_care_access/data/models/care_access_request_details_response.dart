import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'care_access_request_details_response.g.dart';

@JsonSerializable(explicitToJson: true)
class CareAccessRequestDetailsResponse extends Equatable {
  final String requestId;
  final RequesterDetailsModel requester;
  final String relation;
  final String requestedPermission;
  final String requestedAt;
  final List<PermissionCapabilityModel> permissionCapabilities;

  const CareAccessRequestDetailsResponse({
    required this.requestId,
    required this.requester,
    required this.relation,
    required this.requestedPermission,
    required this.requestedAt,
    required this.permissionCapabilities,
  });

  factory CareAccessRequestDetailsResponse.fromJson(
          Map<String, dynamic> json) =>
      _$CareAccessRequestDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CareAccessRequestDetailsResponseToJson(this);

  @override
  List<Object?> get props => [
        requestId,
        requester,
        relation,
        requestedPermission,
        requestedAt,
        permissionCapabilities,
      ];
}

@JsonSerializable()
class RequesterDetailsModel extends Equatable {
  final String userId;
  final String fullName;
  final String phoneNumber;

  const RequesterDetailsModel({
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
  });

  factory RequesterDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$RequesterDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$RequesterDetailsModelToJson(this);

  @override
  List<Object?> get props => [userId, fullName, phoneNumber];
}

@JsonSerializable()
class PermissionCapabilityModel extends Equatable {
  final String title;
  final bool allowed;

  const PermissionCapabilityModel({
    required this.title,
    required this.allowed,
  });

  factory PermissionCapabilityModel.fromJson(Map<String, dynamic> json) =>
      _$PermissionCapabilityModelFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionCapabilityModelToJson(this);

  @override
  List<Object?> get props => [title, allowed];
}
