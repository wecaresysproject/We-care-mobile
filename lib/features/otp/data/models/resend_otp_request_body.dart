import 'package:json_annotation/json_annotation.dart';

part 'resend_otp_request_body.g.dart';

@JsonSerializable()
class ResendOtpRequestBody {
  @JsonKey(name: 'phone')
  final String phoneNumber;
  final String language;

  ResendOtpRequestBody({required this.phoneNumber, required this.language});

  Map<String, dynamic> toJson() => _$ResendOtpRequestBodyToJson(this);
}
