import 'articles.dart';

class ArticleModel extends Article {
  ArticleModel({
    required String id,
    required String title,
    required String description,
    required String content,
    required String author,
    required String url,
    required String urlToImage,
    required DateTime publishedAt,
    required String source,
  }) : super(
    id: id,
    title: title,
    description: description,
    content: content,
    author: author,
    url: url,
    urlToImage: urlToImage,
    publishedAt: publishedAt,
    source: source,
  );

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['source']['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      author: json['author'] ?? 'Unknown',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? 'https://via.placeholder.com/150',
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : DateTime.now(),
      source: json['source']['name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'author': author,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt.toIso8601String(),
      'source': source,
    };
  }
}
