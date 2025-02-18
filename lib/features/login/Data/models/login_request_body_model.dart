import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request_body_model.g.dart';

@JsonSerializable()
class LoginRequestBodyModel {
  LoginRequestBodyModel({
    required this.phoneNumber,
    required this.password,
    required this.language,
  });
  @JsonKey(name: "phone")
  final String phoneNumber;
  final String password;
  final String language;

  Map<String, dynamic> toJson() => _$LoginRequestBodyModelToJson(this);
}
