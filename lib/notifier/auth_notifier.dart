import 'package:abstrak/model/auth_model.dart';
import 'package:abstrak/model/user_model.dart';
import 'package:abstrak/repository/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthNotifier {
  final ValueNotifier<AuthModel?> auth = ValueNotifier(null);
  final ValueNotifier<UserModel?> user = ValueNotifier(null);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<AuthModel?> signIn({
    required String email,
    required String password,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    changeLoading(true);
    auth.value = null;
    try {
      auth.value = await AuthRepo().signIn(email: email, password: password);
      if (auth.value != null) {
        await prefs.setString('token', auth.value?.token?.accessToken ?? '');
        await prefs.setString('refreshToken', auth.value?.token?.refreshToken ?? '');
        await prefs.setString('expiredToken', auth.value?.token?.expiresIn ?? '');
      } else {
        print('Sign in failed');
      }
      changeLoading(false);
    } catch (e) {
      print('Error: $e');
      changeLoading(false);
      auth.value = null;
    }
    return auth.value;
  }

  Future<UserModel?> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    changeLoading(true);
    user.value = null;
    try {
      user.value = await AuthRepo().signUp(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      if (user.value != null) {
        await signIn(email: email, password: password);
      }
      changeLoading(false);
    } catch (e) {
      print('Error: $e');
      changeLoading(false);
      user.value = null;
    }
    return user.value;
  }

  Future<void> signOut() async {
    changeLoading(true);
    await AuthRepo().signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    auth.value = null;
    changeLoading(false);
  }

  void checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('token') ?? '';
    String refreshToken = prefs.getString('refreshToken') ?? '';
    String expiredToken = prefs.getString('expiredToken') ?? '';

    if (accessToken.isNotEmpty && refreshToken.isNotEmpty && expiredToken.isNotEmpty) {
      auth.value = AuthModel(
        token: Token(
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiresIn: expiredToken,
        ),
      );
    } else {
      auth.value = null;
    }
  }

  void changeLoading(bool status) {
    isLoading.value = status;
  }
}
