import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_fcm_token_request_body.g.dart';

@JsonSerializable(explicitToJson: true)
class UpdateFcmTokenRequestBody extends Equatable {
  @JsonKey(name: 'DeviceToken')
  final String userFcmToken;

  const UpdateFcmTokenRequestBody({
    required this.userFcmToken,
  });

  factory UpdateFcmTokenRequestBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateFcmTokenRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateFcmTokenRequestBodyToJson(this);

  @override
  List<Object?> get props => [userFcmToken];
}
