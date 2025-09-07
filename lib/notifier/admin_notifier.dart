import 'package:abstrak/model/artwerks_model.dart';
import 'package:abstrak/repository/admin_repo.dart';
import 'package:flutter/material.dart';

class AdminNotifier {
  final ValueNotifier<int> currentPage = ValueNotifier(1);
  final ValueNotifier<ArtwerksModel?> data = ValueNotifier(null);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<void> getArtwerk({int? page, int? status, int? userId}) async {
    changeLoading(true);
    data.value = null;
    data.value = await AdminRepo().getArtwerks(page: page ?? 1, status: status, userId: userId);
    changeLoading(false);
  }

  void changeLoading(bool status) {
    isLoading.value = status;
  }
}
