import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class AppUser extends HiveObject {
  @HiveField(0)
  String uid;

  @HiveField(1)
  String email;

  @HiveField(2)
  String? displayName;

  AppUser({
    required this.uid,
    required this.email,
    this.displayName,
  });
}

// Create your own lightweight User class
class AuthUser {
  final String uid;
  final String? email;

  AuthUser({required this.uid, this.email});
}