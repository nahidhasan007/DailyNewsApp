import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../domainlayer/entities/articles.dart';
import '../../domainlayer/repostories/news_repository.dart';

class NewsSearchController extends GetxController {
  final NewsRepository _newsRepository;

  NewsSearchController(this._newsRepository);

  final RxList<Article> articles = <Article>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreData = true.obs;
  final RxString currentQuery = ''.obs;

  Future<void> searchArticles(String query, {bool refresh = true}) async {
    if (query.isEmpty) return;

    if (refresh) {
      currentPage.value = 1;
      articles.clear();
      hasMoreData.value = true;
    }

    if (isLoading.value || !hasMoreData.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      currentQuery.value = query;

      final newArticles = await _newsRepository.searchArticles(
        query: query,
        page: currentPage.value,
      );

      if (newArticles.isEmpty) {
        hasMoreData.value = false;
      } else {
        articles.addAll(newArticles);
        currentPage.value++;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void loadMoreResults() {
    if (currentQuery.isNotEmpty) {
      searchArticles(currentQuery.value, refresh: false);
    }
  }
}
