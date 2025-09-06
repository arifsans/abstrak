import 'package:abstrak/model/update_avatar_model.dart';
import 'package:abstrak/model/user_model.dart';
import 'package:abstrak/repository/user_repo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UserNotifier {
  final ValueNotifier<UserModel?> user = ValueNotifier(null);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<UpdateAvatarModel?> updateAvatar = ValueNotifier(null);

  Future<void> getUser() async {
    changeLoading(true);
    user.value = null;
    user.value = await UserRepo().getUser();
    changeLoading(false);
  }

  Future<UpdateAvatarModel?> updateUserAvatar(PlatformFile file) async {
    changeLoading(true);
    updateAvatar.value = null;
    updateAvatar.value = await UserRepo().updateUserAvatar(file);
    changeLoading(false);
    return updateAvatar.value;
  }

  void changeLoading(bool status) {
    isLoading.value = status;
  }
}
