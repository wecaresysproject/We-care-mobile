import 'package:freezed_annotation/freezed_annotation.dart';
part 'verify_otp_request_body.g.dart';

@JsonSerializable()
class VerifyOtpRequestBodyModel {
  @JsonKey(name: 'phone')
  final String phoneNumber;
  final String otp;
  final String language;
  VerifyOtpRequestBodyModel({
    required this.otp,
    required this.phoneNumber,
    required this.language,
  });

  Map<String, dynamic> toJson() => _$VerifyOtpRequestBodyModelToJson(this);
}
