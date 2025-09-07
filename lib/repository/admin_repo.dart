import 'dart:convert';

import 'package:abstrak/base/api.dart';
import 'package:abstrak/model/artwerks_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminRepo {
  Future<ArtwerksModel?> getArtwerks({
    int? page,
  }) async {
    var prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('token') ?? '';
    var res = await ApiConnection().apiCall(
      method: ApiMethod.GET,
      path: 'admin/artwerks?page=${page ?? 1}',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (res != null) {
      var data = res.body;
      return ArtwerksModel.fromJson(jsonDecode(data));
    }

    return null;
  }
}
