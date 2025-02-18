import 'package:json_annotation/json_annotation.dart';

part 'create_new_password_response_model.g.dart';

@JsonSerializable()
class CreateNewPasswordResponseModel {
  final bool success;
  final String message;

  CreateNewPasswordResponseModel({
    required this.success,
    required this.message,
  });

  factory CreateNewPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CreateNewPasswordResponseModelFromJson(json);
}
