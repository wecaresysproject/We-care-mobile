// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_body_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequestBodyModel _$LoginRequestBodyModelFromJson(
        Map<String, dynamic> json) =>
    LoginRequestBodyModel(
      phoneNumber: json['phone'] as String,
      password: json['password'] as String,
      language: json['language'] as String,
    );

Map<String, dynamic> _$LoginRequestBodyModelToJson(
        LoginRequestBodyModel instance) =>
    <String, dynamic>{
      'phone': instance.phoneNumber,
      'password': instance.password,
      'language': instance.language,
    };
