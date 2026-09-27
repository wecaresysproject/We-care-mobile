import 'package:we_care/features/doctor/media_articles/data/models/media_article_model.dart';

class MediaArticlesRequestBodyModel {
  final List<MediaArticleModel> mediaArticles;

  MediaArticlesRequestBodyModel({required this.mediaArticles});

  Map<String, dynamic> toJson() => {
        'mediaArticles':
            mediaArticles.map((article) => article.toJson()).toList(),
      };
}
