import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:session.ai/core/upload_images/upload_repository.dart';

final uploadRepositoryProvider = Provider((ref) => UploadRepository());

final uploadImageProvider =
    StateNotifierProvider<UploadImageNotifier, AsyncValue<String?>>((ref) {
      return UploadImageNotifier(ref.read(uploadRepositoryProvider));
    });

class UploadImageNotifier extends StateNotifier<AsyncValue<String?>> {
  final UploadRepository _repo;

  UploadImageNotifier(this._repo) : super(const AsyncData(null));

  Future<String?> upload(File file) async {
    state = const AsyncLoading();

    try {
      final url = await _repo.uploadImage(file);
      state = AsyncData(url);
      return url;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return null;
    }
  }
}
