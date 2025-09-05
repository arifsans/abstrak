import 'package:abstrak/model/user_model.dart';
import 'package:abstrak/repository/user_repo.dart';
import 'package:flutter/material.dart';

class UserNotifier {
  final ValueNotifier<UserModel?> user = ValueNotifier(null);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<void> getUser() async {
    changeLoading(true);
    user.value = null;
    user.value = await UserRepo().getUser();
    changeLoading(false);
  }

  void changeLoading(bool status) {
    isLoading.value = status;
  }
}
