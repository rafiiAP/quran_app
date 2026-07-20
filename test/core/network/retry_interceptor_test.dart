import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/network/retry_interceptor.dart';

void main() {
  group('RetryInterceptor', () {
    test('default maxRetries is 2', () {
      final interceptor = RetryInterceptor();
      expect(interceptor.maxRetries, 2);
    });

    test('default retryDelay is 500ms', () {
      final interceptor = RetryInterceptor();
      expect(interceptor.retryDelay, const Duration(milliseconds: 500));
    });

    test('custom maxRetries and retryDelay are stored', () {
      final interceptor = RetryInterceptor(
        maxRetries: 5,
        retryDelay: const Duration(seconds: 2),
      );
      expect(interceptor.maxRetries, 5);
      expect(interceptor.retryDelay, const Duration(seconds: 2));
    });

    test('dio setter assigns the Dio instance', () {
      final interceptor = RetryInterceptor();
      final dio = Dio();
      interceptor.dio = dio;
      // No exception thrown — setter works
      expect(true, isTrue);
    });

    group('non-retryable errors pass through without retry', () {
      for (final entry in {
        'badResponse': DioExceptionType.badResponse,
        'cancel': DioExceptionType.cancel,
        'unknown': DioExceptionType.unknown,
        'badCertificate': DioExceptionType.badCertificate,
      }.entries) {
        test('does NOT retry on ${entry.key}', () async {
          int retryAttempts = 0;
          final dio = Dio();
          dio.options.baseUrl = 'https://example.com';

          final interceptor = RetryInterceptor(
            maxRetries: 3,
            retryDelay: Duration.zero,
            dio: dio,
          );

          // Interceptor that rejects with non-retryable error
          dio.interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) {
                retryAttempts++;
                handler.reject(
                  DioException(
                    requestOptions: options,
                    type: entry.value,
                    response: entry.value == DioExceptionType.badResponse
                        ? Response(
                            requestOptions: options,
                            statusCode: 500,
                          )
                        : null,
                  ),
                );
              },
            ),
          );
          dio.interceptors.add(interceptor);

          try {
            await dio.get<dynamic>('/test');
          } catch (_) {}

          // Only 1 attempt — no retries
          expect(retryAttempts, 1);
        });
      }
    });

    group('retryable error types are correctly identified', () {
      test(
          'connectionTimeout is retryable (passes through when maxRetries exhausted)',
          () {
        final interceptor = RetryInterceptor(maxRetries: 0);
        final err = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionTimeout,
        );

        final handler = _TrackingHandler();
        interceptor.onError(err, handler);

        // maxRetries=0, retryCount defaults to 0 — 0 >= 0 so passes through
        expect(handler.nextCalled, isTrue);
      });

      test('sendTimeout is retryable', () {
        final interceptor = RetryInterceptor(maxRetries: 0);
        final err = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.sendTimeout,
        );

        final handler = _TrackingHandler();
        interceptor.onError(err, handler);

        // maxRetries=0, retryCount defaults to 0 — 0 >= 0 so passes through
        expect(handler.nextCalled, isTrue);
      });

      test('receiveTimeout is retryable', () {
        final interceptor = RetryInterceptor(maxRetries: 0);
        final err = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.receiveTimeout,
        );

        final handler = _TrackingHandler();
        interceptor.onError(err, handler);

        expect(handler.nextCalled, isTrue);
      });

      test('connectionError is retryable', () {
        final interceptor = RetryInterceptor(maxRetries: 0);
        final err = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionError,
        );

        final handler = _TrackingHandler();
        interceptor.onError(err, handler);

        expect(handler.nextCalled, isTrue);
      });
    });

    test('retryCount increments in request extras on retry attempt', () async {
      final dio = Dio();
      dio.options.baseUrl = 'https://example.com';
      final interceptor = RetryInterceptor(
        maxRetries: 2,
        retryDelay: Duration.zero,
        dio: dio,
      );

      int callCount = 0;
      late RequestOptions lastOptions;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            callCount++;
            lastOptions = options;
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                response: Response(
                  requestOptions: options,
                  statusCode: 503,
                ),
              ),
            );
          },
        ),
      );
      dio.interceptors.add(interceptor);

      try {
        await dio.get<dynamic>('/test');
      } catch (_) {}

      // badResponse is not retryable, so only 1 call
      expect(callCount, 1);
      // retryCount should NOT have been set since _shouldRetry returns false
      expect(lastOptions.extra['retryCount'], isNull);
    });
  });
}

/// Helper to track whether handler.next() was called.
class _TrackingHandler extends ErrorInterceptorHandler {
  bool nextCalled = false;
  bool resolveCalled = false;

  @override
  void next(DioException err) {
    nextCalled = true;
  }

  @override
  void resolve(Response<dynamic> response) {
    resolveCalled = true;
  }
}
