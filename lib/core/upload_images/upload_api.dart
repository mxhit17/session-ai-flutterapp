import 'dart:io';

import 'package:dio/dio.dart';
import 'package:session.ai/injection_container.dart';
import 'package:session.ai/utils/constants/api_constants.dart';
import 'package:session.ai/utils/network/dio_client.dart';

class UploadApi {
  final Dio _client = sl<DioClient>().instance;

  Future<String> uploadImage(File file, {String type = "speaker"}) async {
    final fileName = file.path.split('/').last;

    final formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });

    final response = await _client.post(
      "${ApiConstants.upload}?type=$type",
      data: formData,
    );

    return response
        .data["url"]; // from your API response :contentReference[oaicite:0]{index=0}
  }
}
