import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'allowed_care_access_response.g.dart';

@JsonSerializable(explicitToJson: true)
class AllowedCareAccessResponse extends Equatable {
  final AccessStatisticsModel statistics;
  final List<GrantedProfileModel> profiles;

  const AllowedCareAccessResponse({
    required this.statistics,
    required this.profiles,
  });

  factory AllowedCareAccessResponse.fromJson(Map<String, dynamic> json) =>
      _$AllowedCareAccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AllowedCareAccessResponseToJson(this);

  @override
  List<Object?> get props => [statistics, profiles];
}

@JsonSerializable()
class AccessStatisticsModel extends Equatable {
  final int totalProfiles;
  final int fullAccessProfiles;
  final int viewOnlyProfiles;

  const AccessStatisticsModel({
    required this.totalProfiles,
    required this.fullAccessProfiles,
    required this.viewOnlyProfiles,
  });

  factory AccessStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$AccessStatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccessStatisticsModelToJson(this);

  @override
  List<Object?> get props => [
        totalProfiles,
        fullAccessProfiles,
        viewOnlyProfiles,
      ];
}

@JsonSerializable()
class GrantedProfileModel extends Equatable {
  final String accessId;
  final String patientId;
  final String patientName;
  final String relation;
  final String permission;
  final String joinedAt;

  const GrantedProfileModel({
    required this.accessId,
    required this.patientId,
    required this.patientName,
    required this.relation,
    required this.permission,
    required this.joinedAt,
  });

  factory GrantedProfileModel.fromJson(Map<String, dynamic> json) =>
      _$GrantedProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$GrantedProfileModelToJson(this);

  @override
  List<Object?> get props => [
        accessId,
        patientId,
        patientName,
        relation,
        permission,
        joinedAt,
      ];
}
