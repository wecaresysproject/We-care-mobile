// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_request_body_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpRequestBodyModel _$SignUpRequestBodyModelFromJson(
        Map<String, dynamic> json) =>
    SignUpRequestBodyModel(
      firstName: json['firstname'] as String,
      lastName: json['lastname'] as String,
      language: json['language'] as String,
      userType: json['userType'] as String,
      phoneNumber: json['phoneNumber'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirmPassword'] as String,
    );

Map<String, dynamic> _$SignUpRequestBodyModelToJson(
        SignUpRequestBodyModel instance) =>
    <String, dynamic>{
      'firstname': instance.firstName,
      'lastname': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
      'language': instance.language,
      'userType': instance.userType,
    };
