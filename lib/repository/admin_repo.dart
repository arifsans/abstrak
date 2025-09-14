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

  Future<bool> updateArtwerkStatus({
    required String artworkId,
    required String status, // '1' for accept, '2' for reject
  }) async {
    var prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('token') ?? '';
    
    var res = await ApiConnection().apiCall(
      method: ApiMethod.POST,
      path: 'admin/artwerks/update',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: {
        'artwerk_id': artworkId,
        'status': status,
      },
    );

    return res != null && res.statusCode == 200;
  }

  Future<bool> acceptArtwerk(String artworkId) async {
    return await updateArtwerkStatus(artworkId: artworkId, status: '1');
  }

  Future<bool> rejectArtwerk(String artworkId) async {
    return await updateArtwerkStatus(artworkId: artworkId, status: '2');
  }
}
