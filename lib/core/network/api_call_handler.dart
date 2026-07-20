import 'package:dio/dio.dart';
import 'package:quran_app/core/error/exceptions.dart';
import 'package:quran_app/core/services/crash_reporter.dart';

/// Shared helper that executes an API call and maps Dio/generic exceptions
/// to typed [ConnectionException] or [ServerException].
///
/// Eliminates repetitive try/catch blocks across datasource implementations.
///
/// Usage:
/// ```dart
/// final result = await apiCall(
///   crashReporter: _crashReporter,
///   call: () async {
///     final response = await _httpClient.get(url: ..., requestName: ...);
///     return MyModel.fromJson(response);
///   },
/// );
/// ```
Future<T> apiCall<T>({
  required CrashReporter crashReporter,
  required Future<T> Function() call,
}) async {
  try {
    return await call();
  } on DioException catch (e, stackTrace) {
    await crashReporter.recordError(e, stackTrace);
    throw ConnectionException(
      e.message ?? 'Gagal terhubung ke server.',
    );
  } catch (e, stackTrace) {
    await crashReporter.recordError(e, stackTrace);
    throw ServerException(e.toString());
  }
}
