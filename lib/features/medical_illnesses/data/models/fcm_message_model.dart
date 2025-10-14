import 'package:json_annotation/json_annotation.dart';

part 'fcm_message_model.g.dart';

@JsonSerializable()
class FcmMessageModel {
  final String pageRoute;
  final int patchNumber;
  final String deviceToken;
  final List<FcmQuestionModel> questions;

  FcmMessageModel({
    required this.pageRoute,
    required this.deviceToken,
    required this.questions,
    required this.patchNumber,
  });

  factory FcmMessageModel.fromJson(Map<String, dynamic> json) =>
      _$FcmMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$FcmMessageModelToJson(this);
}

@JsonSerializable()
class FcmQuestionModel {
  final String id;
  final String text;
  final bool? answer;

  FcmQuestionModel({
    required this.id,
    required this.text,
    this.answer,
  });

  factory FcmQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$FcmQuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$FcmQuestionModelToJson(this);
}
