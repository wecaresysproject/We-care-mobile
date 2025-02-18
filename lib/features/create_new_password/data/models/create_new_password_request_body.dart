import 'package:json_annotation/json_annotation.dart';

part 'create_new_password_request_body.g.dart';

@JsonSerializable()
class CreateNewPasswordRequestBody {
  final String phoneNumber;

  final String newPassword;

  final String confirmPassword;

  final String language;

  CreateNewPasswordRequestBody({
    required this.phoneNumber,
    required this.newPassword,
    required this.confirmPassword,
    required this.language,
  });

  Map<String, dynamic> toJson() => _$CreateNewPasswordRequestBodyToJson(this);
}
