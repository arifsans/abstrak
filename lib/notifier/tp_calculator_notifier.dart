import 'package:abstrak/base/api_state.dart';
import 'package:abstrak/model/tp_calculator_model.dart';
import 'package:abstrak/repository/tp_calculator_repo.dart';
import 'package:flutter/material.dart';

class TPCalculatorNotifier {
  final ValueNotifier<ApiState<TPCalculatorModel?>> data = ValueNotifier(ApiState.initial());

  Future<void> calculateTp({required String username}) async {
    data.value = ApiState.loading();
    try {
      final result = await TPCalculatorRepo().getTp(username: username);
      if (result != null) {
        data.value = ApiState.success(result);
      } else {
        data.value = ApiState.error('Failed to calculate TP');
      }
    } catch (e) {
      data.value = ApiState.error('Error calculating TP: $e');
    }
  }
}
