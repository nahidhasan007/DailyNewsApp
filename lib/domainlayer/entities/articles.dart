class Article {
  final String id;
  final String title;
  final String description;
  final String content;
  final String author;
  final String url;
  final String urlToImage;
  final DateTime publishedAt;
  final String source;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.author,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.source,
  });
}