import 'package:get/get.dart';

import '../../domainlayer/repostories/news_repository.dart';
import '../../domainlayer/repostories/news_repositoryImpl.dart';
import '../network/api_client.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient(), fenix: true);

    // Repositories
    Get.lazyPut<NewsRepository>(() => NewsRepositoryImpl(Get.find()), fenix: true);
    /*Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(), fenix: true);
    Get.lazyPut<BookmarkRepository>(() => BookmarkRepositoryImpl(), fenix: true);*/
  }

}