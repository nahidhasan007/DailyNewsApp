import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domainlayer/repostories/auth_repository.dart';
import '../../domainlayer/repostories/auth_repository_impl.dart';
import '../../domainlayer/repostories/bookmark_repository.dart';
import '../../domainlayer/repostories/bookmark_repository_impl.dart';
import '../../domainlayer/repostories/news_repository.dart';
import '../../domainlayer/repostories/news_repositoryImpl.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../network/api_client.dart';

class InitialBinding extends Bindings {
  // final SharedPreferences sharedPreferences;

  InitialBinding();

  @override
  void dependencies() {
    // Get.put<SharedPreferences>(sharedPreferences, permanent: true);

    Get.lazyPut(() => ApiClient(), fenix: true);
    Get.lazyPut<NewsRepository>(() => NewsRepositoryImpl(Get.find()), fenix: true);
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(), fenix: true);
    Get.lazyPut<BookmarkRepository>(() => BookmarkRepositoryImpl(), fenix: true);

    Get.lazyPut<AuthController>(() => AuthController(Get.find()), fenix: true);
  }
}
