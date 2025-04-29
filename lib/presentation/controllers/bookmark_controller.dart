import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../../domainlayer/entities/articles.dart';
import '../../domainlayer/entities/bookmark_article.dart';
import '../../domainlayer/repostories/auth_repository.dart';
import '../../domainlayer/repostories/bookmark_repository.dart';

class BookmarkController extends GetxController {

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final BookmarkRepository _bookmarkRepository;
  final AuthRepository _authRepository;

  BookmarkController(this._bookmarkRepository, this._authRepository);

  final RxList<BookmarkArticleModel> bookmarks = <BookmarkArticleModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initial load
    getArticlesFromFirebase();
  }


  Future<void> saveArticleToFirebase(Article article) async {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref('bookmarks');
    DatabaseReference newArticleRef = dbRef.push();
    BookmarkArticleModel bookmark = BookmarkArticleModel.fromArticle(article);
    Map<String, dynamic> articleJson = bookmark.toJson();

    try {
      await newArticleRef.set(articleJson);

      print("Article saved successfully!");
      _listenToBookmarks();
    } catch (e) {
      print("Error saving article: $e");
    }
  }


  Future<List<BookmarkArticleModel>> getArticlesFromFirebase() async {
    List<BookmarkArticleModel> articles = [];

    try {
      final snapshot = await _dbRef.child('bookmarks').get();
      print('Fetched data: ${snapshot.value}');

      if (snapshot.exists) {
        final articlesRawMap = snapshot.value as Map<Object?, Object?>;
        articlesRawMap.forEach((key, value) {
          try {
            final castedValue = Map<String, dynamic>.from(value as Map);
            articles.add(BookmarkArticleModel.fromJson(castedValue));
          } catch (e) {
            print('Skipping article with key: $key due to error: $e');
          }
        });

        print('Fetched articles: ${articles.length}');
      } else {
        print('No articles found.');
      }
    } catch (e) {
      print('Error fetching articles: $e');
    }

    bookmarks.value = articles;

    return articles;
  }


  Future<void> loadBookmarks() async {
    getArticlesFromFirebase();
  }

  void _listenToBookmarks() {
    getArticlesFromFirebase();
  }

  bool isBookmarked(Article article) {
    return bookmarks.any((bookmark) => bookmark.url == article.url);
  }

  Future<void> toggleBookmark(Article article) async {
    try {
      if (isBookmarked(article)) {
        await _bookmarkRepository.removeBookmark(article);
      } else {
        await _bookmarkRepository.addBookmark(article);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to update bookmark: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
