import 'package:dio/dio.dart';

/// Dio interceptor that retries failed requests for transient errors.
///
/// Retries on:
/// - Connection timeouts
/// - Send timeouts
/// - Receive timeouts
/// - Connection errors (no internet, DNS failure)
///
/// Does NOT retry on:
/// - HTTP 4xx/5xx responses (server explicitly responded)
/// - Request cancellation
/// - Certificate errors
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    this.maxRetries = 2,
    this.retryDelay = const Duration(milliseconds: 500),
    Dio? dio,
  }) : _dio = dio;

  final int maxRetries;
  final Duration retryDelay;
  Dio? _dio;

  /// Must be called after adding to a Dio instance if not passed in constructor.
  set dio(Dio value) => _dio = value;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

      if (retryCount < maxRetries) {
        err.requestOptions.extra['retryCount'] = retryCount + 1;

        await Future<void>.delayed(
          retryDelay * (retryCount + 1), // exponential-ish backoff
        );

        try {
          final response = await _dio!.fetch<dynamic>(err.requestOptions);
          return handler.resolve(response);
        } on DioException catch (e) {
          return handler.next(e);
        }
      }
    }

    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return switch (err.type) {
      DioExceptionType.connectionTimeout => true,
      DioExceptionType.sendTimeout => true,
      DioExceptionType.receiveTimeout => true,
      DioExceptionType.connectionError => true,
      _ => false,
    };
  }
}
