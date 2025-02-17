// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpResponseModel _$VerifyOtpResponseModelFromJson(
        Map<String, dynamic> json) =>
    VerifyOtpResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: OtpResponseUserData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VerifyOtpResponseModelToJson(
        VerifyOtpResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

OtpResponseUserData _$OtpResponseUserDataFromJson(Map<String, dynamic> json) =>
    OtpResponseUserData(
      firstName: json['firstname'] as String,
      lastName: json['lastname'] as String,
      phoneNumber: json['phone'] as String,
      token: json['token'] as String,
    );

Map<String, dynamic> _$OtpResponseUserDataToJson(
        OtpResponseUserData instance) =>
    <String, dynamic>{
      'firstname': instance.firstName,
      'lastname': instance.lastName,
      'phone': instance.phoneNumber,
      'token': instance.token,
    };
