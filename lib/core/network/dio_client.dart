import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../constants/app_constants.dart';
import '../error/failures.dart';

class DioClient {
  final Dio _dio;

  DioClient() : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: tmdbBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Authorization': 'Bearer ${dotenv.env['TMDB_ACCESS_TOKEN'] ?? ''}',
        'Content-Type': 'application/json',
      },
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) {
          switch (e.type) {
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.receiveTimeout:
            case DioExceptionType.sendTimeout:
            case DioExceptionType.connectionError:
              throw NetworkException(e.message ?? 'Connection failed');
            case DioExceptionType.badResponse:
              final int? status = e.response?.statusCode;
              if (status == 401) throw const UnauthenticatedException();
              if (status == 404) throw const NotFoundException();
              throw ServerException(
                e.response?.statusMessage ?? 'Server error',
                status,
              );
            case DioExceptionType.cancel:
            case DioExceptionType.badCertificate:
            case DioExceptionType.unknown:
              throw ServerException(e.message ?? 'Unknown error');
          }
        },
      ),
    );
  }

  Dio get dio => _dio;
}
