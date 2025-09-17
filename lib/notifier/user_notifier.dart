import 'package:abstrak/base/api_state.dart';
import 'package:abstrak/model/update_avatar_model.dart';
import 'package:abstrak/model/user_model.dart';
import 'package:abstrak/model/users_model.dart';
import 'package:abstrak/repository/user_repo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UserNotifier {
  final ValueNotifier<ApiState<UserModel?>> user = ValueNotifier(ApiState.initial());
  final ValueNotifier<ApiState<UpdateAvatarModel?>> updateAvatar = ValueNotifier(ApiState.initial());
  final ValueNotifier<ApiState<UsersModel?>> users = ValueNotifier(ApiState.initial());

  Future<void> getUser() async {
    user.value = ApiState.loading();
    final result = await UserRepo().getUser();
    if (result != null) {
      user.value = ApiState.success(result);
    } else {
      user.value = ApiState.error('Failed to fetch user data');
    }
  }

  Future<void> updateUserAvatar(PlatformFile file) async {
    updateAvatar.value = ApiState.loading();
    final result = await UserRepo().updateUserAvatar(file);
    if (result != null) {
      updateAvatar.value = ApiState.success(result);
    } else {
      updateAvatar.value = ApiState.error('Failed to update avatar');
    }
  }

  Future<void> getUsersByName({required String name}) async {
    users.value = ApiState.loading();
    final result = await UserRepo().getUserByName(name: name);
    if (result != null) {
      users.value = ApiState.success(result);
    } else {
      users.value = ApiState.error('Failed to fetch users');
    }
  }
}
