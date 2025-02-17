// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpRequestBodyModel _$VerifyOtpRequestBodyModelFromJson(
        Map<String, dynamic> json) =>
    VerifyOtpRequestBodyModel(
      otp: json['otp'] as String,
      phoneNumber: json['phone'] as String,
      language: json['language'] as String,
    );

Map<String, dynamic> _$VerifyOtpRequestBodyModelToJson(
        VerifyOtpRequestBodyModel instance) =>
    <String, dynamic>{
      'phone': instance.phoneNumber,
      'otp': instance.otp,
      'language': instance.language,
    };
