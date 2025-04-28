import 'package:get/get.dart';

import '../../domainlayer/entities/articles.dart';
import '../../domainlayer/repostories/auth_repository.dart';
import '../../domainlayer/repostories/bookmark_repository.dart';

class BookmarkController extends GetxController {
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
    /*_authRepository.userStream.listen((user) {
      if (user != null) {
        // User logged in, sync bookmarks and listen to Firestore changes
        _bookmarkRepository.syncBookmarks();
        _listenToBookmarks();
      } else {
        // User logged out, load local bookmarks
        loadBookmarks();
      }
    });*/

    // Initial load
    loadBookmarks();
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
    _bookmarkRepository.getBookmarksStream().listen(
      (updatedBookmarks) {
        bookmarks.value = updatedBookmarks;
      },
      onError: (e) {
        errorMessage.value = e.toString();
      },
    );
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
