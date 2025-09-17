import 'package:abstrak/base/api_state.dart';
import 'package:abstrak/model/artwerks_model.dart';
import 'package:abstrak/repository/admin_repo.dart';
import 'package:flutter/material.dart';

class AdminNotifier {
  final ValueNotifier<int> currentPage = ValueNotifier(1);
  final ValueNotifier<ApiState<ArtwerksModel?>> data = ValueNotifier(ApiState.initial());

  Future<void> getArtwerk({int? page, int? status, int? userId}) async {
    data.value = ApiState.loading();
    try {
      final result = await AdminRepo().getArtwerks(page: page ?? 1, status: status, userId: userId);
      
      if (result != null) {
        data.value = ApiState.success(result);
      } else {
        data.value = ApiState.error('Failed to fetch artworks');
      }
    } catch (e) {
      data.value = ApiState.error('Error fetching artworks: $e');
    }

  }


  Future<bool> acceptArtwerk(String artworkId) async {
    return await AdminRepo().acceptArtwerk(artworkId);
  }

  Future<bool> rejectArtwerk(String artworkId) async {
    return await AdminRepo().rejectArtwerk(artworkId);
  }

  Future<void> refreshArtwerkList() async {
    await getArtwerk();
  }
}
