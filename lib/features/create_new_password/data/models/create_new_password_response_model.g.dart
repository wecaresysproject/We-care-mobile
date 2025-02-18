// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_new_password_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateNewPasswordResponseModel _$CreateNewPasswordResponseModelFromJson(
        Map<String, dynamic> json) =>
    CreateNewPasswordResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$CreateNewPasswordResponseModelToJson(
        CreateNewPasswordResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
    };
