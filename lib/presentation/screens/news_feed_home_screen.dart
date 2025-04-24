import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/presentation/controllers/news_controller.dart';
import 'package:newsapp/presentation/widgets/news_article_item.dart';

import '../widgets/news_category_tabs.dart';

class NewsFeedHomeScreen extends GetView<NewsController> {
  const NewsFeedHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Feed'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Get.toNamed('/search'),
          ),
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () => Get.toNamed('/bookmarks'),
          ),
        ],
      ),
      body: Column(
        children: [
          CategoryTabs(
            onCategorySelected: controller.changeCategory,
            selectedCategory: controller.selectedCategory,
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.articles.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.isNotEmpty &&
                  controller.articles.isEmpty) {
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
                        onPressed:
                            () => controller.getTopHeadlines(refresh: true),
                        child: Text('Try Again'),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.getTopHeadlines(refresh: true),
                child: ListView.builder(
                  itemCount:
                      controller.articles.length +
                      (controller.hasMoreData.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.articles.length) {
                      controller.getTopHeadlines();
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final article = controller.articles[index];
                    return ArticleItem(
                      article: article,
                      onTap:
                          () => Get.toNamed(
                            '/article-details',
                            arguments: article,
                          ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
