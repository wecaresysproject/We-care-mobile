import 'package:freezed_annotation/freezed_annotation.dart';

part 'forget_password_request_body_model.g.dart';

@JsonSerializable()
class ForgetPasswordRequestBodyModel {
  @JsonKey(name: 'phone')
  final String phoneNumber;
  final String language;

  ForgetPasswordRequestBodyModel({
    required this.language,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => _$ForgetPasswordRequestBodyModelToJson(this);
}
