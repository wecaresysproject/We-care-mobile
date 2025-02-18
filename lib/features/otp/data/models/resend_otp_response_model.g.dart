// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resend_otp_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResendOtpResponseModel _$ResendOtpResponseModelFromJson(
        Map<String, dynamic> json) =>
    ResendOtpResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      otp: json['otp'] as String,
    );

Map<String, dynamic> _$ResendOtpResponseModelToJson(
        ResendOtpResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'otp': instance.otp,
    };
