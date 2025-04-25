import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Article extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String content;

  @HiveField(4)
  final String author;

  @HiveField(5)
  final String url;

  @HiveField(6)
  final String urlToImage;

  @HiveField(7)
  final DateTime publishedAt;

  @HiveField(8)
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