import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/presentation/controllers/search_controller.dart';

import '../../domainlayer/entities/articles.dart';
import '../widgets/news_article_item.dart';

class SearchPage extends GetView<NewsSearchController> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search news...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              controller.searchArticles(value);
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              if (_searchController.text.isNotEmpty) {
                controller.searchArticles(_searchController.text);
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.articles.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty && controller.articles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Something went wrong!', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text(controller.errorMessage.value),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () => controller.searchArticles(_searchController.text),
                  child: Text('Try Again'),
                ),
              ],
            ),
          );
        }

        if (controller.articles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text('Search for news', style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount:
              controller.articles.length +
              (controller.hasMoreData.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.articles.length) {
              controller.loadMoreResults();
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final Article article = controller.articles[index];
            return ArticleItem(
              article: article,
              onTap: () => Get.toNamed('/article-details', arguments: article),
            );
          },
        );
      }),
    );
  }
}
