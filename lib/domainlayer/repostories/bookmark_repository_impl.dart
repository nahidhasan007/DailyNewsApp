import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/articleModel.dart';
import '../entities/articles.dart';
import 'bookmark_repository.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  @override
  Future<void> addBookmark(Article article) async {
    // Save to local storage first
    await _saveLocalBookmark(article);

    // If user is logged in, save to Firestore
    if (_userId != null) {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('bookmarks')
          .doc(article.url)
          .set((article as ArticleModel).toJson());
    }
  }

  @override
  Future<void> removeBookmark(Article article) async {
    // Remove from local storage
    await _removeLocalBookmark(article);

    // If user is logged in, remove from Firestore
    if (_userId != null) {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('bookmarks')
          .doc(article.url)
          .delete();
    }
  }

  @override
  Future<List<Article>> getBookmarks() async {
    // If user is logged in, get bookmarks from Firestore
    if (_userId != null) {
      try {
        final snapshot = await _firestore
            .collection('users')
            .doc(_userId)
            .collection('bookmarks')
            .get();

        return snapshot.docs
            .map((doc) => ArticleModel.fromJson(doc.data()))
            .toList();
      } catch (e) {
        // If error, fall back to local bookmarks
        return _getLocalBookmarks();
      }
    }

    // If not logged in, get from local storage
    return _getLocalBookmarks();
  }

  @override
  Stream<List<Article>> getBookmarksStream() {
    if (_userId != null) {
      return _firestore
          .collection('users')
          .doc(_userId)
          .collection('bookmarks')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => ArticleModel.fromJson(doc.data()))
            .toList();
      });
    }

    // If not logged in, return empty stream
    return Stream.fromFuture(_getLocalBookmarks());
  }

  @override
  Future<void> syncBookmarks() async {
    if (_userId == null) return;

    // Get local bookmarks
    final localBookmarks = await _getLocalBookmarks();

    // Get cloud bookmarks
    final snapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('bookmarks')
        .get();

    final cloudBookmarks = snapshot.docs
        .map((doc) => ArticleModel.fromJson(doc.data()))
        .toList();

    // Find bookmarks that are in local but not in cloud
    for (final article in localBookmarks) {
      final exists = cloudBookmarks.any((cloudArticle) =>
      cloudArticle.url == article.url);

      if (!exists) {
        // Upload to cloud
        await _firestore
            .collection('users')
            .doc(_userId)
            .collection('bookmarks')
            .doc(article.url)
            .set((article as ArticleModel).toJson());
      }
    }

    // Find bookmarks that are in cloud but not in local
    for (final article in cloudBookmarks) {
      final exists = localBookmarks.any((localArticle) =>
      localArticle.url == article.url);

      if (!exists) {
        // Save to local
        await _saveLocalBookmark(article);
      }
    }
  }

  // Helper methods for local storage
  Future<void> _saveLocalBookmark(Article article) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await _getLocalBookmarks();

    // Check if already exists
    if (bookmarks.any((bookmark) => bookmark.url == article.url)) {
      return;
    }

    bookmarks.add(article);
    final jsonList = bookmarks
        .map((article) => (article as ArticleModel).toJson())
        .toList();

    await prefs.setString('bookmarks', jsonEncode(jsonList));
  }

  Future<void> _removeLocalBookmark(Article article) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await _getLocalBookmarks();

    bookmarks.removeWhere((bookmark) => bookmark.url == article.url);

    final jsonList = bookmarks
        .map((article) => (article as ArticleModel).toJson())
        .toList();

    await prefs.setString('bookmarks', jsonEncode(jsonList));
  }

  Future<List<Article>> _getLocalBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarksJson = prefs.getString('bookmarks');

    if (bookmarksJson == null || bookmarksJson.isEmpty) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(bookmarksJson);
    return decoded
        .map((json) => ArticleModel.fromJson(json))
        .toList();
  }

}