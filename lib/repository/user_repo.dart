import 'dart:convert';

import 'package:abstrak/base/api.dart';
import 'package:abstrak/helper/convert_file_to_cast.dart';
import 'package:abstrak/model/update_avatar_model.dart';
import 'package:abstrak/model/user_model.dart';
import 'package:abstrak/model/users_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepo {
  Future<UserModel?> getUser() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('token') ?? '';

      var res = await ApiConnection().apiCall(
        method: ApiMethod.GET,
        path: 'user',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (res != null) {
        var data = res.body;
        final user = UserModel.fromJson(jsonDecode(data));
        final roleId = user.data?.roleId ?? '1';
        // Save role ID to SharedPreferences
        await prefs.setString('role_id', roleId);
        // Save user ID to SharedPreferences
        if (user.data?.id != null || (user.data?.id ?? '').isNotEmpty) {
          await prefs.setString('user_id', user.data?.id ?? '');
        }
        return user;
      }
    } catch (e) {
      print('Error signing in: $e');
    }

    return null;
  }

  Future<UpdateAvatarModel?> updateUserAvatar(PlatformFile file) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('token') ?? '';
      final avatar = ConvertFileToCast.convert(file.bytes!);

      var res = await ApiConnection().apiCall(
        method: ApiMethod.MULTIPART,
        path: 'user/update-avatar',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          'avatar': await MultipartFile.fromBytes(
            'avatar',
            avatar,
            filename: file.name,
          ),
        },
      );

      if ((res?.statusCode ?? 400) > 300) {
        print('Error updating avatar: ${res?.body}');
        return null;
      }

      if (res != null) {
        var data = res.body;
        final newData = UpdateAvatarModel.fromJson(jsonDecode(data));
        if (newData.status == true) {
          return newData;
        } else {
          print('Error updating avatar: ${newData.message}');
          return null;
        }
      }
    } catch (e) {
      print('Error updating avatar: $e');
    }

    return null;
  }

  Future<UsersModel?> getUserByName({required String name}) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('token') ?? '';

      var res = await ApiConnection().apiCall(
        method: ApiMethod.POST,
        path: 'user/users-by-name',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          'name': name,
        },
      );

      if (res != null) {
        var data = res.body;
        return UsersModel.fromJson(jsonDecode(data));
      }
    } catch (e) {
      print('Error getting user by name: $e');
    }

    return null;
  }
}
