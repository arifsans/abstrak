import 'dart:convert';

import 'package:abstrak/base/api.dart';
import 'package:abstrak/model/artwerks_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminRepo {
  Future<ArtwerksModel?> getArtwerks({
    int? page,
    int? status,
    int? userId,
  }) async {
    var prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('token') ?? '';
    var res = await ApiConnection().apiCall(
      method: ApiMethod.GET,
      path: 'admin/artwerks',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      queryParams: {
        'page': page ?? 1,
        if (status != null) 'status': status,
        if (userId != null) 'user_id': userId,
      },
    );

    if (res != null) {
      var data = res.body;
      return ArtwerksModel.fromJson(jsonDecode(data));
    }

    return null;
  }
}
