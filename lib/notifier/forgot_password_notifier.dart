import 'package:abstrak/base/api_state.dart';
import 'package:abstrak/model/forgot_password_model.dart';
import 'package:abstrak/repository/forgot_password_repo.dart';
import 'package:flutter/material.dart';

class ForgotPasswordNotifier {
  final ValueNotifier<ApiState<ForgotPasswordModel?>> forgotPassword = ValueNotifier(ApiState.initial());

  final ForgotPasswordRepo _repository = ForgotPasswordRepo();

  // Method to switch to real API when available
  Future<ForgotPasswordModel?> sendResetEmail({
    required String email,
  }) async {
    // Set loading state
    forgotPassword.value = ApiState.loading();
    
    try {
      ForgotPasswordModel? result = await _repository.sendResetEmail(email: email);
      
      if (result != null) {
        if (result.status) {
          // Set success state
          forgotPassword.value = ApiState.success(result);
        } else {
          // Set error state with message from API
          forgotPassword.value = ApiState.error(result.message);
        }
        return result;
      } else {
        // Set error state for null result
        forgotPassword.value = ApiState.error('Unable to process your request. Please try again.');
        return null;
      }
    } catch (e) {
      // Set error state for exceptions
      forgotPassword.value = ApiState.error('An unexpected error occurred. Please try again.');
      print('Error sending reset email: $e');
      return null;
    }
  }

  void reset() {
    forgotPassword.value = ApiState.initial();
  }
}