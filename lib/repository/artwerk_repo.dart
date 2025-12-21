import 'dart:convert';
import 'dart:typed_data';

import 'package:abstrak/base/api.dart';
import 'package:abstrak/helper/convert_file_to_cast.dart';
import 'package:abstrak/model/artwerks_model.dart';
import 'package:abstrak/model/create_artwerks_model.dart';
import 'package:abstrak/model/users_model.dart';
import 'package:abstrak/model/interaction_model.dart';
import 'package:abstrak/model/comment_model.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArtwerkRepo {
  Future<ArtwerksModel?> getArtwerks({
    int? page,
    int? userId,
    int? status,
  }) async {
    var res = await ApiConnection().apiCall(
      method: ApiMethod.GET,
      path: 'artwerk',
      queryParams: {
        'page': page ?? 1,
        if (userId != null) 'user_id': userId,
        if (status != null) 'status': status,
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

  // Interaction Methods - Updated to match Vania API
  Future<bool> toggleArtwerkInteraction({
    required int artwerkId,
    required int interactionId, // 1=like, 2=share, 3=view, 4=seen
  }) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('token') ?? '';

      var requestBody = {
        'artwerk_id': '$artwerkId',
        'interaction_id': '$interactionId',
      };

      var res = await ApiConnection().apiCall(
        method: ApiMethod.POST,
        path: 'interactions/toggle',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: requestBody,
      );

      if (res != null) {
        var data = res.body;

        try {
          var jsonResponse = jsonDecode(data);

          // Check if the response has the expected structure
          if (jsonResponse['status'] == true) {
            print('✅ Interaction toggle successful');
            return true;
          } else {
            print('❌ API returned false status: ${jsonResponse['message']}');
            return false;
          }
        } catch (parseError) {
          print('❌ Error parsing response: $parseError');
          print('Raw response: $data');
          return false;
        }
      } else {
        print('❌ No response received from API');
      }
    } catch (e) {
      print('❌ Error toggling artwork interaction: $e');
      print('Stack trace: ${StackTrace.current}');
    }

    return false;
  }

  Future<InteractionStatsModel?> getArtwerkInteractionCounts(
      {required String artwerkId}) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('token') ?? '';

      var res = await ApiConnection().apiCall(
        method: ApiMethod.GET,
        path: 'interactions/counts',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        queryParams: {
          'artwerk_id': int.parse(artwerkId),
        },
      );

      if (res != null) {
        var data = res.body;
        return InteractionStatsModel.fromJson(jsonDecode(data));
      }
    } catch (e) {
      print('Error getting artwork interaction counts: $e');
    }

    return null;
  }

  Future<Map<String, bool>?> getUserInteractions(
      {required String artwerkId}) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('token') ?? '';

      var res = await ApiConnection().apiCall(
        method: ApiMethod.GET,
        path: 'interactions/user',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        queryParams: {
          'artwerk_id': int.parse(artwerkId),
        },
      );

      if (res != null) {
        var data = jsonDecode(res.body);
        print('getUserInteractions response: $data');

        if (data['status'] == true && data['data'] != null) {
          Map<String, bool> userInteractions = {};
          for (var interaction in data['data']) {
            // Use interaction_name from the API response
            String interactionName =
                interaction['interaction_name']?.toString() ?? '';
            userInteractions[interactionName] = true;
          }
          print('Parsed user interactions: $userInteractions');
          return userInteractions;
        }
      }
    } catch (e) {
      print('Error getting user interactions: $e');
    }

    return null;
  }

  // Comment Methods - Updated to match Vania API
  Future<CommentsListModel?> getArtwerkComments({
    required String artwerkId,
    int? page,
    int? totalData,
  }) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('token') ?? '';

      var res = await ApiConnection().apiCall(
        method: ApiMethod.GET,
        path: 'comments/artwerk',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        queryParams: {
          'artwerk_id': int.parse(artwerkId),
          'page': page ?? 1,
          'total_data': totalData ?? 20,
        },
      );

      if (res != null) {
        var data = res.body;
        return CommentsListModel.fromJson(jsonDecode(data));
      }
    } catch (e) {
      print('Error getting artwork comments: $e');
    }

    return null;
  }

  Future<CommentModel?> createComment({
    required String artwerkId,
    required String content,
  }) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('token') ?? '';

      var res = await ApiConnection().apiCall(
        method: ApiMethod.POST,
        path: 'comments/create',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          'artwerk_id': artwerkId,
          'comment': content,
        },
      );

      if (res != null) {
        var data = res.body;
        return CommentModel.fromJson(jsonDecode(data));
      }
    } catch (e) {
      print('Error creating comment: $e');
    }

    return null;
  }

  Future<CommentModel?> updateComment({
    required String commentId,
    required String content,
  }) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('token') ?? '';

      var res = await ApiConnection().apiCall(
        method: ApiMethod.POST,
        path: 'comments/update',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        queryParams: {
          'comment_id': int.parse(commentId),
        },
        body: {
          'comment': content,
        },
      );

      if (res != null) {
        var data = res.body;
        return CommentModel.fromJson(jsonDecode(data));
      }
    } catch (e) {
      print('Error updating comment: $e');
    }

    return null;
  }

  Future<CommentModel?> deleteComment({required String commentId}) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('token') ?? '';

      var res = await ApiConnection().apiCall(
        method: ApiMethod.POST,
        path: 'comments/delete',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          'id': int.parse(commentId),
        },
      );

      if (res != null) {
        var data = res.body;
        return CommentModel.fromJson(jsonDecode(data));
      }
    } catch (e) {
      print('Error deleting comment: $e');
    }

    return null;
  }

  Future<bool> toggleCommentInteraction({
    required String commentId,
    required int interactionId, // 1=like
  }) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('token') ?? '';

      var res = await ApiConnection().apiCall(
        method: ApiMethod.POST,
        path: 'interactions/toggle',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          'artwerk_comment_id': int.parse(commentId),
          'interaction_id': interactionId,
        },
      );

      if (res != null) {
        var data = res.body;
        var jsonResponse = jsonDecode(data);

        // Check if the response has the expected structure
        if (jsonResponse['status'] == true) {
          return true;
        } else {
          print(
              'Comment interaction API returned false status: ${jsonResponse['message']}');
          return false;
        }
      }
    } catch (e) {
      print('Error toggling comment interaction: $e');
    }

    return false;
  }
}
