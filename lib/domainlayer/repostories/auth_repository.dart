import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsapp/domainlayer/entities/app_user.dart';

abstract class AuthRepository {
  Future<AuthUser?> signIn(String email, String password);
  Future<AuthUser?> signUp(String email, String password);
  Future<void> signOut();
}