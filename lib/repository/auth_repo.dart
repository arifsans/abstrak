import 'dart:convert';
import 'dart:io';

import 'package:abstrak/base/api.dart';
import 'package:abstrak/model/api_exception.dart';
import 'package:abstrak/model/auth_model.dart';
import 'package:abstrak/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  Future<UserModel?> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      var res = await ApiConnection().apiCall(
        method: ApiMethod.POST,
        path: 'user/register',
        body: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );

      if (res == null) {
        throw SignUpException.networkError();
      }

      if (res.statusCode == 200 || res.statusCode == 201) {
        var data = res.body;
        return UserModel.fromJson(jsonDecode(data));
      } else if (res.statusCode == 400) {
        // Parse error response for specific error types
        try {
          final errorData = jsonDecode(res.body);
          final message = errorData['message'] ?? errorData['error'] ?? 'Invalid request';
          
          // Check for specific error types based on message content
          if (message.toString().toLowerCase().contains('email') && message.toString().toLowerCase().contains('already')) {
            throw SignUpException.emailExists();
          } else if (message.toString().toLowerCase().contains('password')) {
            throw SignUpException.weakPassword();
          } else if (message.toString().toLowerCase().contains('phone')) {
            throw SignUpException.invalidPhone();
          } else {
            throw SignUpException(message: message, statusCode: res.statusCode);
          }
        } catch (e) {
          if (e is SignUpException) rethrow;
          throw SignUpException(
            message: 'Invalid request. Please check your information and try again.',
            statusCode: res.statusCode,
          );
        }
      } else if (res.statusCode == 409) {
        throw SignUpException.emailExists();
      } else if (res.statusCode >= 500) {
        throw SignUpException.serverError();
      } else {
        // Try to parse error message from response
        try {
          final errorData = jsonDecode(res.body);
          final message = errorData['message'] ?? errorData['error'] ?? 'Unknown error occurred';
          throw SignUpException(message: message, statusCode: res.statusCode);
        } catch (e) {
          if (e is SignUpException) rethrow;
          throw SignUpException(
            message: 'Sign up failed. Please try again.',
            statusCode: res.statusCode,
          );
        }
      }
    } on SignUpException {
      rethrow; // Re-throw SignUpException as-is
    } on SocketException {
      throw SignUpException.networkError();
    } catch (e) {
      print('Error signing up: $e');
      throw SignUpException.unknown(e.toString());
    }
  }

  Future<AuthModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      var res = await ApiConnection().apiCall(
        method: ApiMethod.POST,
        path: 'user/login',
        body: {
          'email': email,
          'password': password,
        },
      );

      if (res != null) {
        var data = res.body;
        return AuthModel.fromJson(jsonDecode(data));
      }
    } catch (e) {
      print('Error signing in: $e');
    }

    return null;
  }

  Future<void> signOut() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('token') ?? '';
      await ApiConnection().apiCall(
        method: ApiMethod.POST,
        path: 'user/logout',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
    } catch (e) {
      print('Error signing out: $e');
    }

    return null;
  }
}
