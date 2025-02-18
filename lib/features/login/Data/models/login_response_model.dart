import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  LoginResponseModel({
    required this.isSuccess,
    required this.message,
    required this.userData,
  });
  @JsonKey(name: "success")
  bool isSuccess;
  String message;

  @JsonKey(name: "data")
  LoginResponseUserData userData;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
}

@JsonSerializable()
class LoginResponseUserData {
  LoginResponseUserData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.token,
  });

  int id;
  @JsonKey(name: "firstname")
  String firstName;
  @JsonKey(name: "lastname")
  String lastName;

  @JsonKey(name: "phone")
  String phoneNumber;
  String token;

  factory LoginResponseUserData.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseUserDataFromJson(json);
}
