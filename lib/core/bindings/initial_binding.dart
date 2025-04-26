import 'package:get/get.dart';
import 'package:newsapp/presentation/controllers/news_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domainlayer/repostories/auth_repository.dart';
import '../../domainlayer/repostories/auth_repository_impl.dart';
import '../../domainlayer/repostories/bookmark_repository.dart';
import '../../domainlayer/repostories/bookmark_repository_impl.dart';
import '../../domainlayer/repostories/news_repository.dart';
import '../../domainlayer/repostories/news_repositoryImpl.dart';
import '../../domainlayer/usecases/get_top_news_headlines_useCase.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../network/api_client.dart';

class InitialBinding extends Bindings {
  // final SharedPreferences sharedPreferences;

  InitialBinding();

  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient(), fenix: true);
    Get.lazyPut<NewsRepository>(() => NewsRepositoryImpl(Get.find()), fenix: true);
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(), fenix: true);
    Get.lazyPut<BookmarkRepository>(() => BookmarkRepositoryImpl(), fenix: true);

    Get.lazyPut<GetTopHeadlinesUseCase>(() => GetTopHeadlinesUseCase(Get.find()), fenix: true); // <-- moved up
    Get.lazyPut<NewsController>(() => NewsController(Get.find()), fenix: true);

    Get.lazyPut<AuthController>(() => AuthController(Get.find()), fenix: true);
  }
}
