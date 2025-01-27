import 'package:abstrak/model/artwerks_model.dart';
import 'package:abstrak/repository/artwerk_repo.dart';
import 'package:flutter/material.dart';

class ArtwerkNotifier {
  final ValueNotifier<ArtwerksModel?> data = ValueNotifier(null);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<void> getArtwerk({int? page}) async {
    changeLoading(true);
    data.value = null;
    data.value = await ArtwerkRepo().getArtwerks(page: page ?? 1);
    changeLoading(false);
  }

  void changeLoading(bool status) {
    isLoading.value = status;
  }
}
