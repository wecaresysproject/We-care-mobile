// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpResponseModel _$SignUpResponseModelFromJson(Map<String, dynamic> json) =>
    SignUpResponseModel(
      isSuccess: json['success'] as String,
      message: json['message'] as String,
      userData: UserData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SignUpResponseModelToJson(
        SignUpResponseModel instance) =>
    <String, dynamic>{
      'success': instance.isSuccess,
      'message': instance.message,
      'data': instance.userData,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      id: json['id'] as String,
      firstName: json['firstname'] as String,
      lastName: json['lastname'] as String,
      phoneNumber: json['phone'] as String,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'firstname': instance.firstName,
      'lastname': instance.lastName,
      'phone': instance.phoneNumber,
    };
