import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_care_access_request.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateCareAccessRequest extends Equatable {
  final String targetUserId;
  final String relation;
  final String permission;

  const CreateCareAccessRequest({
    required this.targetUserId,
    required this.relation,
    required this.permission,
  });

  factory CreateCareAccessRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCareAccessRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCareAccessRequestToJson(this);

  @override
  List<Object?> get props => [
        targetUserId,
        relation,
        permission,
      ];
}
