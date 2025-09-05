import 'dart:convert';

import 'package:abstrak/base/api.dart';
import 'package:abstrak/model/user_model.dart';
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
        return UserModel.fromJson(jsonDecode(data));
      }
    } catch (e) {
      print('Error signing in: $e');
    }

    return null;
  }
}
