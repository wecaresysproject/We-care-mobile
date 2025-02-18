// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_new_password_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateNewPasswordRequestBody _$CreateNewPasswordRequestBodyFromJson(
        Map<String, dynamic> json) =>
    CreateNewPasswordRequestBody(
      phoneNumber: json['phoneNumber'] as String,
      newPassword: json['newPassword'] as String,
      confirmPassword: json['confirmPassword'] as String,
      language: json['language'] as String,
    );

Map<String, dynamic> _$CreateNewPasswordRequestBodyToJson(
        CreateNewPasswordRequestBody instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'newPassword': instance.newPassword,
      'confirmPassword': instance.confirmPassword,
      'language': instance.language,
    };
