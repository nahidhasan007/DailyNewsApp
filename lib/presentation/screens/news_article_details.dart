import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';

import '../../domainlayer/entities/articles.dart';
import '../controllers/bookmark_controller.dart';

class ArticleDetailsPage extends GetView<BookmarkController> {
  @override
  Widget build(BuildContext context) {
    final Article article = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Article'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
            },
          ),
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isBookmarked(article)
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                color:
                    controller.isBookmarked(article)
                        ? Colors.yellow[700]
                        : null,
              ),
              onPressed: () => controller.toggleBookmark(article),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image
            CachedNetworkImage(
              imageUrl: article.urlToImage,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: Center(child: CircularProgressIndicator()),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: Icon(Icons.error, size: 50),
                  ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 12),

                  // Source and Date
                  Row(
                    children: [
                      Text(
                        article.source,
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('•', style: TextStyle(color: Colors.grey)),
                      SizedBox(width: 12),
                      Text(
                        DateFormat('MMM dd, yyyy').format(article.publishedAt),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),

                  if (article.author.isNotEmpty && article.author != 'Unknown')
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'By ${article.author}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                  SizedBox(height: 16),

                  // Description
                  Text(
                    article.description,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),

                  SizedBox(height: 16),

                  // Content
                  Text(article.content, style: TextStyle(fontSize: 16)),

                  SizedBox(height: 24),

                  // Read More Button
                  /*Center(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.article),
                      label: Text('Read Full Article'),
                      onPressed: () async {
                        final url = Uri.parse(article.url);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
