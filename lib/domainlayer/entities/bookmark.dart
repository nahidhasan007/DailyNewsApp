import 'package:hive/hive.dart';

part 'bookmark.g.dart';

@HiveType(typeId: 1)
class Bookmark extends HiveObject {
  @HiveField(0)
  String userId;

  @HiveField(1)
  String articleId;

  Bookmark({required this.userId, required this.articleId});
}
