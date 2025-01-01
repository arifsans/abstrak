import 'package:abstrak/model/tp_calculator_model.dart';
import 'package:abstrak/repository/tp_calculator_repo.dart';
import 'package:flutter/material.dart';

class TPCalculatorNotifier {
  final ValueNotifier<TPCalculatorModel?> data = ValueNotifier(null);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<void> calculateTp({required String username}) async {
    changeLoading(true);
    data.value = null;
    data.value = await TPCalculatorRepo().getTp(username: username);
    changeLoading(false);
  }

  void changeLoading(bool status) {
    isLoading.value = status;
  }
}
