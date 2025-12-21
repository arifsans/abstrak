import 'dart:convert';
import 'dart:io';

import 'package:abstrak/base/api.dart';
import 'package:abstrak/model/forgot_password_model.dart';

class ForgotPasswordRepo {
  Future<ForgotPasswordModel?> sendResetEmail({
    required String email,
  }) async {
    try {
      var res = await ApiConnection().apiCall(
        method: ApiMethod.POST,
        path: 'user/forgot-password',
        body: {
          'email': email,
        },
      );

      if (res != null) {
        if (res.statusCode == 200 || res.statusCode == 201) {
          var data = res.body;
          return ForgotPasswordModel.fromJson(jsonDecode(data));
        } else if (res.statusCode == 404) {
          return ForgotPasswordModel(
            status: false,
            message: 'No account found with this email address. Please check your email or create a new account.',
          );
        } else if (res.statusCode == 429) {
          return ForgotPasswordModel(
            status: false,
            message: 'Too many requests. Please wait before trying again.',
          );
        } else if (res.statusCode >= 500) {
          return ForgotPasswordModel(
            status: false,
            message: 'Server error. Please try again later or contact support.',
          );
        } else {
          // Try to parse error message from response
          try {
            final errorData = jsonDecode(res.body);
            final message = errorData['message'] ?? 'Unable to process your request. Please try again.';
            return ForgotPasswordModel(
              status: false,
              message: message,
            );
          } catch (e) {
            return ForgotPasswordModel(
              status: false,
              message: 'Unable to process your request. Please try again.',
            );
          }
        }
      } else {
        return ForgotPasswordModel(
          status: false,
          message: 'Network error. Please check your connection and try again.',
        );
      }
    } on SocketException {
      return ForgotPasswordModel(
        status: false,
        message: 'No internet connection. Please check your network and try again.',
      );
    } catch (e) {
      print('Error sending reset email: $e');
      return ForgotPasswordModel(
        status: false,
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }
}