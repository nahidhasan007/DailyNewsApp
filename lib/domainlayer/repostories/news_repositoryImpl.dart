import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../entities/articleModel.dart';
import '../entities/articles.dart';
import 'news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final ApiClient _apiClient;

  NewsRepositoryImpl(this._apiClient);

  @override
  Future<List<Article>> getTopHeadlines({
    String category = '',
    String country = 'us',
    int page = 1,
  }) async {
    try {
      final internetConnectionChecker =
          InternetConnectionChecker.createInstance();
      bool isConnected = await internetConnectionChecker.hasConnection;

      // if (!isConnected) {
      //   return await getSavedHeadlines();
      // }

      final queryParams = {'country': country, 'page': page, 'pageSize': 20};

      if (category.isNotEmpty) {
        queryParams['category'] = category;
      }

      final response = await _apiClient.get(
        ApiConstants.topHeadlinesEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> articlesJson = response.data['articles'];
        List<Article> articles =
            articlesJson.map((json) => Article.fromJson(json)).toList();
        final box = await Hive.openBox<List<Article>>('articlesBox');
        await box.put(
          'topHeadlines',
          articles,
        ); // Save articles under the key 'topHeadlines'

        return articles;
      } else {
        throw Exception('Failed to load top headlines');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<Article>> getSavedHeadlines() async {
    final box = await Hive.openBox<List<Article>>('articlesBox');
    List<Article>? articles = box.get('topHeadlines');

    // If articles exist in Hive
    if (articles != null) {
      return articles;
    }

    // If no articles are saved, return an empty list
    return [];
  }

  @override
  Future<List<Article>> searchArticles({
    required String query,
    int page = 1,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.everythingEndpoint,
        queryParameters: {
          'q': query,
          'page': page,
          'pageSize': 20,
          'sortBy': 'publishedAt',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> articlesJson = response.data['articles'];
        return articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search articles');
      }
    } catch (e) {
      throw e;
    }
  }
}
