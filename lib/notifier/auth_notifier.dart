import 'package:abstrak/base/api_state.dart';
import 'package:abstrak/model/api_exception.dart';
import 'package:abstrak/model/auth_model.dart';
import 'package:abstrak/model/user_model.dart';
import 'package:abstrak/repository/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthNotifier {
  final ValueNotifier<ApiState<AuthModel?>> auth = ValueNotifier(ApiState.initial());
  final ValueNotifier<ApiState<UserModel?>> user = ValueNotifier(ApiState.initial());

  Future<AuthModel?> signIn({
    required String email,
    required String password,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Set loading state
    auth.value = ApiState.loading();
    
    try {
      AuthModel? authResult = await AuthRepo().signIn(email: email, password: password);
      
      if (authResult != null) {
        // Set success state
        auth.value = ApiState.success(authResult);
        
        // Save tokens to shared preferences
        await prefs.setString('token', authResult.token?.accessToken ?? '');
        await prefs.setString('refreshToken', authResult.token?.refreshToken ?? '');
        await prefs.setString('expiredToken', authResult.token?.expiresIn ?? '');
        
        return authResult;
      } else {
        // Set error state for failed sign in
        auth.value = ApiState.error('Sign in failed');
        print('Sign in failed');
        return null;
      }
    } catch (e) {
      // Set error state for exceptions
      auth.value = ApiState.error('Error: $e');
      print('Error: $e');
      return null;
    }
  }

  Future<UserModel?> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    // Set loading state
    user.value = ApiState.loading();
    
    try {
      UserModel? userResult = await AuthRepo().signUp(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      
      if (userResult != null) {
        // Set success state
        user.value = ApiState.success(userResult);
        
        return userResult;
      } else {
        // Set error state for null result
        user.value = ApiState.error('Sign up failed');
        return null;
      }
    } on SignUpException catch (e) {
      // Set error state for SignUpException
      user.value = ApiState.error(e.message);
      rethrow; // Re-throw to be handled by the UI
    } catch (e) {
      print('Error: $e');
      // Set error state for generic exceptions
      user.value = ApiState.error('Error: $e');
      // Convert generic errors to SignUpException
      throw SignUpException.unknown(e.toString());
    }
  }

  Future<void> signOut() async {
    await AuthRepo().signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    auth.value = ApiState.initial();
  }

  void checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('token') ?? '';
    String refreshToken = prefs.getString('refreshToken') ?? '';
    String expiredToken = prefs.getString('expiredToken') ?? '';

    if (accessToken.isNotEmpty && refreshToken.isNotEmpty && expiredToken.isNotEmpty) {
      AuthModel authModel = AuthModel(
        token: Token(
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiresIn: expiredToken,
        ),
      );
      auth.value = ApiState.success(authModel);
    } else {
      auth.value = ApiState.initial();
    }
  }

}
