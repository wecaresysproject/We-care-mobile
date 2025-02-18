// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponseModel _$LoginResponseModelFromJson(Map<String, dynamic> json) =>
    LoginResponseModel(
      isSuccess: json['success'] as bool,
      message: json['message'] as String,
      userData:
          LoginResponseUserData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseModelToJson(LoginResponseModel instance) =>
    <String, dynamic>{
      'success': instance.isSuccess,
      'message': instance.message,
      'data': instance.userData,
    };

LoginResponseUserData _$LoginResponseUserDataFromJson(
        Map<String, dynamic> json) =>
    LoginResponseUserData(
      id: (json['id'] as num).toInt(),
      firstName: json['firstname'] as String,
      lastName: json['lastname'] as String,
      phoneNumber: json['phone'] as String,
      token: json['token'] as String,
    );

Map<String, dynamic> _$LoginResponseUserDataToJson(
        LoginResponseUserData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstname': instance.firstName,
      'lastname': instance.lastName,
      'phone': instance.phoneNumber,
      'token': instance.token,
    };
