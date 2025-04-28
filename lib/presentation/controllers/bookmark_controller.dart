import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:newsapp/domainlayer/entities/articleModel.dart';

import '../../domainlayer/entities/articles.dart';
import '../../domainlayer/repostories/auth_repository.dart';
import '../../domainlayer/repostories/bookmark_repository.dart';

class BookmarkController extends GetxController {

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final BookmarkRepository _bookmarkRepository;
  final AuthRepository _authRepository;

  BookmarkController(this._bookmarkRepository, this._authRepository);

  final RxList<Article> bookmarks = <Article>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to authentication state changes
    /*_authRepository.isUserLoggedIn();
    _authRepository.isUserLoggedIn(); {
      if (user != null) {
        // User logged in, sync bookmarks and listen to Firestore changes
        _bookmarkRepository.syncBookmarks();
        _listenToBookmarks();
      } else {
        // User logged out, load local bookmarks
        loadBookmarks();
      }
    })*/

    // Initial load
    getArticlesFromFirebase();
    loadBookmarks();
  }


  Future<void> saveArticleToFirebase(Article article) async {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref('bookmarks');

    // Create a new reference for the article
    DatabaseReference newArticleRef = dbRef.push();

    // Convert the article to JSON
    Map<String, dynamic> articleJson = article.toJson();

    try {
      // Save the article data to Firebase Realtime Database
      await newArticleRef.set(articleJson);

      print("Article saved successfully!");
      _listenToBookmarks();
    } catch (e) {
      print("Error saving article: $e");
    }
  }


  Future<List<Article>> getArticlesFromFirebase() async {
    List<Article> articles = [];

    try {
      final snapshot = await _dbRef.child('bookmarks').get();
      print('Fetched data: ${snapshot.value}'); // Log the fetched raw data

      // Check if data exists
      if (snapshot.exists) {
        Map<Object?, Object?> articlesMap = snapshot.value as Map<Object?, Object?>;

        // Log the articlesMap structure to see the exact format
        print('Articles map structure: $articlesMap');

        articlesMap.forEach((key, value) {
          // Safely cast the value to a Map<String, dynamic> before passing to Article.fromJson
          if (value is Map<String, dynamic>) {
            print('Processing article with key: $key, value: $value');
            articles.add(Article.fromJson(value));
          } else {
            print('Skipping article with key: $key due to unexpected structure');
          }
        });

        print('Fetched articles: ${articles.length}');
      } else {
        print('No articles found.');
      }
    } catch (e) {
      print('Error fetching articles: $e');
    }

    return articles;
  }




  Future<void> loadBookmarks() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _bookmarkRepository.getBookmarks();
      bookmarks.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
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
