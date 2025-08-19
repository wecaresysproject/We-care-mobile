import 'package:json_annotation/json_annotation.dart';

part 'post_fcm_token_request_model.g.dart';

@JsonSerializable()
class PostFcmTokenRequest {
  final bool isActivated;
  final String deviceToken;

  PostFcmTokenRequest({
    required this.isActivated,
    required this.deviceToken,
  });

  factory PostFcmTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$PostFcmTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PostFcmTokenRequestToJson(this);
}
