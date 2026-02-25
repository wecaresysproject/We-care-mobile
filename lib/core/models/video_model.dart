import 'package:json_annotation/json_annotation.dart';

part 'video_model.g.dart';

@JsonSerializable()
class VideoModel {
  @JsonKey(name: 'videoLink')
  final String? videoLink;
  @JsonKey(name: 'videoCoverImage')
  final String? videoCoverImage;

  VideoModel({
    this.videoLink,
    this.videoCoverImage,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) =>
      _$VideoModelFromJson(json);

  Map<String, dynamic> toJson() => _$VideoModelToJson(this);
}
