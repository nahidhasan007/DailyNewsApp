import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../domainlayer/entities/articles.dart';
import '../../domainlayer/usecases/get_top_news_headlines_useCase.dart';

class NewsController extends GetxController {
  final GetTopHeadlinesUseCase _getTopHeadlinesUseCase;

  NewsController(this._getTopHeadlinesUseCase);

  final RxList<Article> articles = <Article>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreData = true.obs;
  final RxString selectedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getTopHeadlines();
  }

  Future<void> getTopHeadlines({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      articles.clear();
      hasMoreData.value = true;
    }

    if (isLoading.value || !hasMoreData.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final newArticles = await _getTopHeadlinesUseCase.execute(
        category: selectedCategory.value,
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

  void changeCategory(String category) {
    if (selectedCategory.value == category) return;

    selectedCategory.value = category;
    articles.clear();
    currentPage.value = 1;
    hasMoreData.value = true;
    getTopHeadlines();
  }
}