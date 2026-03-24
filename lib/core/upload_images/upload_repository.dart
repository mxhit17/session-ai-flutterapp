import 'dart:io';

import 'package:session.ai/core/upload_images/upload_api.dart';

class UploadRepository {
  final UploadApi _api = UploadApi();

  Future<String> uploadImage(File file) async {
    try {
      return await _api.uploadImage(file);
    } catch (e) {
      throw Exception("Image upload failed");
    }
  }
}
