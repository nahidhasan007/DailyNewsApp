import '../entities/articles.dart';

abstract class NewsRepository {
  Future<List<Article>> getTopHeadlines({
    String category = '',
    String country = 'us',
    int page = 1,
  });

  Future<List<Article>> searchArticles({
    required String query,
    int page = 1,
  });
}