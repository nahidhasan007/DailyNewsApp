import 'package:firebase_database/firebase_database.dart';
import 'package:newsapp/domainlayer/entities/app_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_repository.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for utf8

class AuthRepositoryImpl implements AuthRepository {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  String? _currentUserId;

  // Helper: Hash passwords
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<AuthUser?> signUp(String email, String password) async {
    try {
      // Check if email already exists
      final snapshot = await _dbRef.child('users').orderByChild('email').equalTo(email).get();

      if (snapshot.exists) {
        throw Exception('Email already in use');
      }

      // Save user
      final newUserRef = _dbRef.child('users').push();
      await newUserRef.set({
        'email': email,
        'password': _hashPassword(password),
      });

      _currentUserId = newUserRef.key;
      return AuthUser(uid: _currentUserId!, email: email);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<AuthUser?> signIn(String email, String password) async {
    try {
      final snapshot = await _dbRef.child('users').orderByChild('email').equalTo(email).get();

      if (snapshot.exists) {
        Map data = snapshot.value as Map;
        for (var entry in data.entries) {
          var user = entry.value;
          if (user['password'] == _hashPassword(password)) {
            _currentUserId = entry.key;
            return AuthUser(uid: entry.key, email: user['email']);
          }
        }
      }
      throw Exception('Invalid email or password');
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> signOut() async {
    _currentUserId = null;
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;
    print('Checked login state: $loggedIn');
    return loggedIn;
  }

  @override
  Future<void> saveLoginState(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
    print('Saved login state: $isLoggedIn');
  }
}

