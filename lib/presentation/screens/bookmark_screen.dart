import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/presentation/widgets/news_article_item.dart';

import '../controllers/auth_controller.dart';
import '../controllers/bookmark_controller.dart';

class BookmarksPage extends GetView<BookmarkController> {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
        actions: [
          Obx(() => authController.isLoggedIn
              ? IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => authController.signOut(),
          )
              : IconButton(
            icon: Icon(Icons.login),
            onPressed: () => Get.toNamed('/login'),
          ),
          ),
        ],
      ),
      body: Obx(() {
        // Show auth prompt if not logged in
        if (!authController.isLoggedIn) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Sign in to sync your bookmarks',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.toNamed('/login'),
                  child: Text('Sign In'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
              ],
            ),
          );
        }

        // Show loading indicator
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        // Show error message
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Something went wrong!',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(controller.errorMessage.value),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.loadBookmarks(),
                  child: Text('Try Again'),
                ),
              ],
            ),
          );
        }

        // Show empty state
        if (controller.bookmarks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No bookmarks yet',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Articles you bookmark will appear here',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        // Show bookmarks list
        return ListView.builder(
          itemCount: controller.bookmarks.length,
          itemBuilder: (context, index) {
            final article = controller.bookmarks[index];
            return Dismissible(
              key: Key(article.url),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (_) {
                controller.toggleBookmark(article);
              },
              child: ArticleItem(
                article: article,
                onTap: () => Get.toNamed(
                  '/article-details',
                  arguments: article,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
