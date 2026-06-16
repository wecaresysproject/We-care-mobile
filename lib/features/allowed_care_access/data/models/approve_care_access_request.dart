import 'package:json_annotation/json_annotation.dart';

part 'approve_care_access_request.g.dart';

@JsonSerializable(explicitToJson: true)
class ApproveCareAccessRequest {
  final String requestId;
  @JsonKey(name: 'ApprovedPermission')
  final String approvedPermission;

  ApproveCareAccessRequest({
    required this.requestId,
    required this.approvedPermission,
  });

  factory ApproveCareAccessRequest.fromJson(Map<String, dynamic> json) =>
      _$ApproveCareAccessRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ApproveCareAccessRequestToJson(this);
}
