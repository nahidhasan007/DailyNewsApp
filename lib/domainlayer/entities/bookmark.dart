import 'package:hive/hive.dart';


@HiveType(typeId: 1)
class Bookmark extends HiveObject {
  @HiveField(0)
  String userId;

  @HiveField(1)
  String articleId;

  Bookmark({required this.userId, required this.articleId});
}
