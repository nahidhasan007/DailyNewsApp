import '../entities/articles.dart';
import '../repostories/news_repository.dart';

class GetTopHeadlinesUseCase {
  final NewsRepository _newsRepository;

  GetTopHeadlinesUseCase(this._newsRepository);

  Future<List<Article>> execute({
    String category = '',
    String country = 'us',
    int page = 1,
  }) {
    return _newsRepository.getTopHeadlines(
      category: category,
      country: country,
      page: page,
    );
  }
}
