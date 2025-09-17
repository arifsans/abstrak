import 'dart:typed_data';

import 'package:abstrak/base/api_state.dart';
import 'package:abstrak/model/artwerks_model.dart' as a;
import 'package:abstrak/model/create_artwerks_model.dart' as c;
import 'package:abstrak/model/users_model.dart';
import 'package:abstrak/repository/artwerk_repo.dart';
import 'package:flutter/material.dart';

class ArtwerkNotifier {
  final ValueNotifier<ApiState<a.ArtwerksModel?>> data = ValueNotifier(ApiState.initial());
  final ValueNotifier<ApiState<c.CreateArtwerksModel?>> createArtwerkData = ValueNotifier(ApiState.initial());
  final ValueNotifier<ApiState<UsersModel?>> users = ValueNotifier(ApiState.initial());

  Future<void> getArtwerk({int? page, int? userId, int? status}) async {
    data.value = ApiState.loading();

    try {
      final result = await ArtwerkRepo()
          .getArtwerks(page: page ?? 1, userId: userId, status: status);

      if (result != null) {
        // For page-based navigation, always replace the data
        data.value = ApiState.success(result);
      } else {
        data.value = ApiState.error('Failed to fetch artworks');
      }
    } catch (e) {
      data.value = ApiState.error('Error fetching artworks: $e');
    }
  }

  Future<bool> uploadArtwerk({
    required String name,
    required String description,
    required Uint8List imageData,
    required String fileName,
  }) async {
    createArtwerkData.value = ApiState.loading();

    try {
      final result = await ArtwerkRepo().createArtwerk(
        name: name,
        description: description,
        imageData: imageData,
        fileName: fileName,
      );

      if (result != null && result.status == true) {
        createArtwerkData.value = ApiState.success(result);
        // Refresh the artwork list to show the new upload
        await getArtwerk(page: 1);
        return true;
      } else {
        createArtwerkData.value = ApiState.error('Failed to upload artwork');
        return false;
      }
    } catch (e) {
      debugPrint('Error uploading artwork: $e');
      createArtwerkData.value = ApiState.error('Error uploading artwork: $e');
      return false;
    }
  }

  Future<void> filterUserByName({required String name}) async {
    users.value = ApiState.loading();

    try {
      final result = await ArtwerkRepo().filterUserByName(name: name);
      if (result != null) {
        users.value = ApiState.success(result);
      } else {
        users.value = ApiState.error('Failed to fetch users');
      }
    } catch (e) {
      users.value = ApiState.error('Error fetching users: $e');
    }
  }
}
