import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../domainlayer/repostories/auth_repository.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  AuthController(this._authRepository);

  final Rx<User?> user = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isUserLoggedIn = false.obs;

  @override
  void onInit() async {
    super.onInit();
  }
  @override
  void onReady() {
    super.onReady();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    isUserLoggedIn.value = await _authRepository.isUserLoggedIn();
  }

  bool get isLoggedIn => isUserLoggedIn.value;

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _authRepository.signIn(email, password);
      _authRepository.saveLoginState(true);
      isUserLoggedIn.value = true;
      Get.offAllNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _authRepository.signUp(email, password);
      _authRepository.saveLoginState(true);
      Get.offAllNamed(Routes.LOGIN);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _authRepository.signOut();
      await _authRepository.saveLoginState(false);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        errorMessage.value = 'No user found with this email.';
        break;
      case 'wrong-password':
        errorMessage.value = 'Wrong password provided.';
        break;
      case 'email-already-in-use':
        errorMessage.value = 'The email address is already in use.';
        break;
      case 'weak-password':
        errorMessage.value = 'The password is too weak.';
        break;
      default:
        errorMessage.value = e.message ?? 'An unknown error occurred.';
    }
  }
}