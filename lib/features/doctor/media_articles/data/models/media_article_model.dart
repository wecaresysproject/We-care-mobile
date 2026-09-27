import 'package:json_annotation/json_annotation.dart';

part 'media_article_model.g.dart';

@JsonSerializable()
class MediaArticleModel {
  final String title;
  final String subject;
  final String mediaLink;

  MediaArticleModel({
    required this.title,
    required this.subject,
    required this.mediaLink,
  });

  Map<String, dynamic> toJson() => _$MediaArticleModelToJson(this);
}
