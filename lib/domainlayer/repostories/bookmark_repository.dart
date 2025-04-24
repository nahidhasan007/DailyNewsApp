import '../entities/articles.dart';

abstract class BookmarkRepository {
  Future<void> addBookmark(Article article);
  Future<void> removeBookmark(Article article);
  Future<List<Article>> getBookmarks();
  Stream<List<Article>> getBookmarksStream();
  Future<void> syncBookmarks();
}