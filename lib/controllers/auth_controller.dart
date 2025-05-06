import 'package:flutter/material.dart';
import 'package:meyor_lite/repository/auth_repository.dart';
import 'package:meyor_lite/views/screens/login_screen.dart';

import '../main.dart';
import '../models/auth_model.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  bool isLoading = false;

  Future<bool> isAuthenticated() async {
    final auth = await authRepository.getAuth();
    if (auth == null || auth.expiresAt == null) {
      return false;
    }

    // tokenni tekshirish
    final tokenExpiresAt = auth.expiresAt;
    if (DateTime.now().isBefore(tokenExpiresAt!)) {
      return true;
    }
    return false;
  }

  Future<AuthModel?> getAuth() async {
    return await authRepository.getAuth();
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final authModel = await authRepository.register(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      isLoading = true;
      notifyListeners();

      final authModel = await authRepository.login(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await authRepository.logout();
  }

  void autoLogout() async {
    final currentContext = myAppnavigatorKey.currentContext;

    if (currentContext != null) {
      final authModel = await authRepository.getAuth();

      if (authModel == null || authModel.expiresAt == null) {
        return;
      }

      final tokenExpiresAt = authModel.expiresAt;
      final differenceInSeconds =
          tokenExpiresAt!.difference(DateTime.now()).inSeconds;

      Future.delayed(Duration(seconds: differenceInSeconds), () {
        if (currentContext.mounted) {
          Navigator.pushReplacement(
            currentContext,
            MaterialPageRoute(
              builder: (ctx) {
                return LoginScreen();
              },
            ),
          );
        }
      });
    }
  }
}
