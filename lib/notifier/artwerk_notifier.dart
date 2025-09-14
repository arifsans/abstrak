import 'dart:typed_data';

import 'package:abstrak/model/artwerks_model.dart' as a;
import 'package:abstrak/model/create_artwerks_model.dart' as c;
import 'package:abstrak/model/users_model.dart';
import 'package:abstrak/repository/artwerk_repo.dart';
import 'package:flutter/material.dart';

class ArtwerkNotifier {
  final ValueNotifier<a.ArtwerksModel?> data = ValueNotifier(null);
  final ValueNotifier<c.CreateArtwerksModel?> createArtwerkData = ValueNotifier(null);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<UsersModel?> users = ValueNotifier(null);

  Future<void> getArtwerk({int? page}) async {
    changeLoading(true);
    if ((page ?? 1) == 1) {
      data.value = null;
    }
    final result = await ArtwerkRepo().getArtwerks(page: page ?? 1);
    if (result != null) {
      if ((page ?? 1) == 1 || data.value == null) {
        // First page or no existing data, replace everything
        data.value = result;
      } else {
        // Subsequent pages, append to existing results
        final existingResults = data.value?.data?.result ?? [];
        final newResults = result.data?.result ?? [];

        // Create updated data with combined results
        data.value = a.ArtwerksModel(
          status: result.status,
          message: result.message,
          data: a.Data(
            result: [...existingResults, ...newResults],
            currentPage: result.data?.currentPage,
            perPage: result.data?.perPage,
            total: result.data?.total,
            lastPage: result.data?.lastPage,
            isFirst: result.data?.isFirst,
            isLast: result.data?.isLast,
            hasMore: result.data?.hasMore,
          ),
        );
      }
    }
    changeLoading(false);
  }

  void changeLoading(bool status) {
    isLoading.value = status;
  }

  Future<bool> uploadArtwerk({
    required String name,
    required String description,
    required Uint8List imageData,
    required String fileName,
  }) async {
    changeLoading(true);
    try {
      final result = await ArtwerkRepo().createArtwerk(
        name: name,
        description: description,
        imageData: imageData,
        fileName: fileName,
      );
      
      if (result != null && result.status == true) {
        createArtwerkData.value = result;
        // Refresh the artwork list to show the new upload
        await getArtwerk(page: 1);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Error uploading artwork: $e');
      return false;
    } finally {
      changeLoading(false);
    }
  }

  Future<void> filterUserByName({required String name}) async {
    changeLoading(true);
    users.value = null;
    users.value = await ArtwerkRepo().filterUserByName(name: name);
    changeLoading(false);
  }
}
