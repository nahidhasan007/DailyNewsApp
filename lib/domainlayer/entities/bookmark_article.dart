import 'articles.dart';

class BookmarkArticleModel {
  final String title;
  final String description;
  final String author;
  final String url;

  BookmarkArticleModel({
    required this.title,
    required this.description,
    required this.author,
    required this.url,
  });

  factory BookmarkArticleModel.fromJson(Map<String, dynamic> json) {
    return BookmarkArticleModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      author: json['author'] ?? 'Unknown',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'author': author,
      'url': url,
    };
  }

  factory BookmarkArticleModel.fromArticle(Article article) {
    return BookmarkArticleModel(
      title: article.title,
      description: article.description,
      author: article.author,
      url: article.url,
    );
  }

}
