import 'package:dio/dio.dart';
import 'package:session.ai/injection_container.dart';
import 'package:session.ai/utils/storage/preference_manager.dart';

class DioClient {
  final Dio _dio;

  DioClient(String baseUrl)
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    // Add interceptor
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );

    // add more custom interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // can add bearer token here
          String token =
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NjksImVtYWlsIjoibW11ZGdhbDY3QGdtYWlsLmNvbSIsInJvbGUiOiJDT01QQU5ZIiwiaWF0IjoxNzUyNDg0Mjg0LCJleHAiOjE3NTI2NTcwODR9.W_DpdydE2ZuXaLUX103TUl2m275HD9MRBWVnZ2s5w6w";
          final _prefs = sl<PreferencesManager>();
          final storedToken = _prefs.getAccessToken();
          if (storedToken != null && storedToken != '') {
            token = storedToken;
          }
          options.headers.addAll({'Authorization': 'Bearer $token'});
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // can add global error handling here
          return handler.next(e);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
      ),
    );
  }

  Dio get instance => _dio;
}
