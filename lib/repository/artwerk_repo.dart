import 'dart:convert';

import 'package:abstrak/base/api.dart';
import 'package:abstrak/model/artwerks_model.dart';

class ArtwerkRepo {
  Future<ArtwerksModel?> getArtwerks({
    int? page,
    int? userId,
  }) async {
    var res = await ApiConnection().apiCall(
      method: ApiMethod.GET,
      path: 'artwerk',
      queryParams: {
        'page': page ?? 1,
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
