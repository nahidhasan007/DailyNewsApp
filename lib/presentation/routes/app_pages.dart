import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:newsapp/presentation/screens/login_screen.dart';
import 'package:newsapp/presentation/screens/news_article_details.dart';
import 'package:newsapp/presentation/screens/news_feed_home_screen.dart';
import 'package:newsapp/presentation/screens/sign_up_screen.dart';

import '../bindings/auth_binding.dart';
import '../bindings/bookmark_binding.dart';
import '../bindings/news_binding.dart';
import '../bindings/search_bindings.dart';
import '../screens/bookmark_screen.dart';
import '../screens/search_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => NewsFeedHomeScreen(),
      binding: NewsBinding(),
    ),
    GetPage(
      name: Routes.ARTICLE_DETAILS,
      page: () => ArticleDetailsPage(),
      binding: BookmarkBinding(),
    ),
    GetPage(
      name: Routes.BOOKMARKS,
      page: () => BookmarksPage(),
      bindings: [BookmarkBinding(), AuthBinding()],
    ),
    GetPage(
      name: Routes.SEARCH,
      page: () => SearchPage(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => SignupPage(),
      binding: AuthBinding(),
    ),
  ];
}