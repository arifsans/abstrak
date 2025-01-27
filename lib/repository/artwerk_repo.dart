import 'dart:convert';

import 'package:abstrak/base/api.dart';
import 'package:abstrak/model/artwerks_model.dart';

class ArtwerkRepo {
  Future<ArtwerksModel?> getArtwerks({
    int? page,
  }) async {
    var res = await ApiConnection().apiCall(
      method: ApiMethod.GET,
      path: 'artwerk/$page',
    );

    if (res != null) {
      var data = res.body;
      return ArtwerksModel.fromJson(jsonDecode(data)['data']);
    }

    return null;
  }
}
