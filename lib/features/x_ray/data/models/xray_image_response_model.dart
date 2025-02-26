import 'package:freezed_annotation/freezed_annotation.dart';

part 'xray_image_response_model.g.dart';

@JsonSerializable()
class XrayImageResponseModel {
  final String imageUrl;
  @JsonKey(name: 'success')
  final bool isImageUploadedSuccessfully;
  final String message;

  XrayImageResponseModel({
    required this.imageUrl,
    required this.message,
    required this.isImageUploadedSuccessfully,
  });

  factory XrayImageResponseModel.fromJson(Map<String, dynamic> json) =>
      _$XrayImageResponseModelFromJson(json);
}
