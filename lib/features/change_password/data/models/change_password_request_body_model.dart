import 'package:json_annotation/json_annotation.dart';

part 'change_password_request_body_model.g.dart';

@JsonSerializable()
class ChangePasswordRequestBodyModel {
  @JsonKey(name: "OldPassword")
  final String oldPassword;

  @JsonKey(name: "NewPassword")
  final String newPassword;

  @JsonKey(name: "ConfirmPassword")
  final String confirmPassword;

  ChangePasswordRequestBodyModel({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => _$ChangePasswordRequestBodyModelToJson(this);
}
