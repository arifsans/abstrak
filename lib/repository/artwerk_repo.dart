import 'dart:convert';
import 'dart:typed_data';

import 'package:abstrak/base/api.dart';
import 'package:abstrak/helper/convert_file_to_cast.dart';
import 'package:abstrak/model/artwerks_model.dart';
import 'package:abstrak/model/create_artwerks_model.dart';
import 'package:abstrak/model/users_model.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<CreateArtwerksModel?> createArtwerk({
    required String name,
    required String description,
    required Uint8List imageData,
    required String fileName,
  }) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('token') ?? '';
      final image = ConvertFileToCast.convert(imageData);

      var res = await ApiConnection().apiCall(
        method: ApiMethod.MULTIPART,
        path: 'artwerk/create',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          'name': name,
          'description': description,
          'image': await MultipartFile.fromBytes(
            'image',
            image,
            filename: fileName,
          ),
        },
      );

      if (res != null) {
        var data = res.body;
        return CreateArtwerksModel.fromJson(jsonDecode(data));
      }
    } catch (e) {
      print('Error creating artwork: $e');
    }

    return null;
  }

  Future<UsersModel?> filterUserByName({required String name}) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('token') ?? '';

      var res = await ApiConnection().apiCall(
        method: ApiMethod.POST,
        path: 'artwerk/filter-by-user',
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
