import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NewsService {
  late final Dio _dio;

  NewsService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://danyeon.cloud:50443',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );

    // 로깅 인터셉터 추가
    _dio.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (obj) => debugPrint('🌐 [DIO] $obj'),
      ),
    );
  }

  Future<Response> getCardNews({
    required int offset,
    required int limit,
    String? category,
    String? level,
  }) async {
    return await _dio.get(
      '/v1/cardnews',
      queryParameters: {
        'offset': offset,
        'limit': limit,
        if (category != null && category != 'all') 'category': category,
        if (level != null && level != 'all') 'level': level,
      },
    );
  }
}
