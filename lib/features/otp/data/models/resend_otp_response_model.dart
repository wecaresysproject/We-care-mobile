import 'package:json_annotation/json_annotation.dart';

part 'resend_otp_response_model.g.dart';

@JsonSerializable()
class ResendOtpResponseModel {
  bool success;
  String message;
  String otp;

  ResendOtpResponseModel({
    required this.success,
    required this.message,
    required this.otp,
  });
  factory ResendOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResendOtpResponseModelFromJson(json);
}
