import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_otp_response_model.g.dart';

@JsonSerializable()
class VerifyOtpResponseModel {
  bool success;
  String message;
  OtpResponseUserData data;

  VerifyOtpResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseModelFromJson(json);
}

@JsonSerializable()
class OtpResponseUserData {
  @JsonKey(name: 'firstname')
  String firstName;
  @JsonKey(name: 'lastname')
  String lastName;
  @JsonKey(name: 'phone')
  String phoneNumber;
  String token;

  OtpResponseUserData({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.token,
  });

  factory OtpResponseUserData.fromJson(Map<String, dynamic> json) =>
      _$OtpResponseUserDataFromJson(json);
}
