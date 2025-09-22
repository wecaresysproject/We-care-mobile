import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_response_model.g.dart';

@JsonSerializable()
class SignUpResponseModel {
  SignUpResponseModel({
    required this.isSuccess,
    required this.message,
    required this.userData,
  });
  @JsonKey(name: "success")
  bool isSuccess;
  String message;

  @JsonKey(name: "data")
  UserData userData;

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseModelFromJson(json);
}

@JsonSerializable()
class UserData {
  UserData({
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
  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
