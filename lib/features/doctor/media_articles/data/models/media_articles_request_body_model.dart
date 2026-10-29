import 'package:we_care/features/doctor/media_articles/data/models/media_article_model.dart';

class MediaArticlesRequestBodyModel {
  final List<MediaArticleModel> mediaArticles;

  MediaArticlesRequestBodyModel({required this.mediaArticles});

  factory MediaArticlesRequestBodyModel.fromJson(Map<String, dynamic> json) =>
      MediaArticlesRequestBodyModel(
        mediaArticles: (json['mediaArticles'] as List? ?? const [])
            .map((e) => MediaArticleModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'mediaArticles':
            mediaArticles.map((article) => article.toJson()).toList(),
      };
}
