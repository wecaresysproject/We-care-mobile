import 'package:freezed_annotation/freezed_annotation.dart';

part 'forget_password_response_model.g.dart';

@JsonSerializable()
class ForgetPasswordResponseModel {
  ForgetPasswordResponseModel({
    required this.isSuccess,
    required this.message,
  });
  @JsonKey(name: "success")
  bool isSuccess;
  String message;

  factory ForgetPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordResponseModelFromJson(json);
}
