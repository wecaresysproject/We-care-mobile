import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_request_body_model.g.dart';

@JsonSerializable()
class SignUpRequestBodyModel {
  @JsonKey(name: 'firstname')
  final String firstName;
  @JsonKey(name: 'lastname')
  final String lastName;
  final String phoneNumber;
  final String password;
  final String confirmPassword;
  final String language;
  final String userType;

  SignUpRequestBodyModel({
    required this.firstName,
    required this.lastName,
    required this.language,
    required this.userType,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => _$SignUpRequestBodyModelToJson(this);
}
