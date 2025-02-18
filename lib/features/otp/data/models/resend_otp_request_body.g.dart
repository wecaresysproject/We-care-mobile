// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resend_otp_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResendOtpRequestBody _$ResendOtpRequestBodyFromJson(
        Map<String, dynamic> json) =>
    ResendOtpRequestBody(
      phoneNumber: json['phone'] as String,
      language: json['language'] as String,
    );

Map<String, dynamic> _$ResendOtpRequestBodyToJson(
        ResendOtpRequestBody instance) =>
    <String, dynamic>{
      'phone': instance.phoneNumber,
      'language': instance.language,
    };
