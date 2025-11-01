import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_image_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UploadImageResponseModel {
  final String imageUrl;
  @JsonKey(name: 'success')
  final bool isImageUploadedSuccessfully;
  final String message;

  UploadImageResponseModel({
    required this.imageUrl,
    required this.message,
    required this.isImageUploadedSuccessfully,
  });

  factory UploadImageResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UploadImageResponseModelFromJson(json);
}
