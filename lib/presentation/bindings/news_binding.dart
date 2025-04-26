import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:newsapp/domainlayer/usecases/get_top_news_headlines_useCase.dart';

import '../../domainlayer/repostories/news_repository.dart';
import '../controllers/news_controller.dart';

class NewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetTopHeadlinesUseCase>(
      () => GetTopHeadlinesUseCase(Get.find<NewsRepository>()),
      fenix: true,
    );
    Get.lazyPut<NewsController>(
      () => NewsController(Get.find<GetTopHeadlinesUseCase>()),
      fenix: true,
    );
  }
}
