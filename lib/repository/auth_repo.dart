import 'dart:convert';

import 'package:abstrak/base/api.dart';
import 'package:abstrak/model/auth_model.dart';
import 'package:abstrak/model/user_model.dart';

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

      if (res != null) {
        var data = res.body;
        return UserModel.fromJson(jsonDecode(data));
      }
    } catch (e) {
      print('Error signing up: $e');
    }

    return null;
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
}
