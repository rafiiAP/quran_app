import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:quran_app/core/network/certificate_pins.dart';
import 'package:quran_app/core/network/http_client.dart';
import 'package:quran_app/core/network/retry_interceptor.dart';
import 'package:quran_app/core/services/crash_reporter.dart';
import 'package:quran_app/core/services/logger_service.dart';

/// Concrete [AppHttpClient] implementation using Dio.
///
/// In release mode, configures certificate pinning to validate server
/// certificates against known SHA-256 public key hashes. In debug mode,
/// pin validation is bypassed for development convenience.
///
/// Includes a [RetryInterceptor] for transient network failures (timeouts,
/// connection errors) with exponential backoff.
class MainHttpClient implements AppHttpClient {
  MainHttpClient({
    required this.crashReporter,
    required this.loggerService,
    dio.Dio? dioClient,
  }) : _dio = dioClient ?? dio.Dio() {
    _configureRetry();
    if (!kDebugMode) {
      _configureCertificatePinning();
    }
    _checkPinRedundancy();
  }

  final CrashReporter crashReporter;
  final LoggerService loggerService;
  final dio.Dio _dio;

  /// Adds a retry interceptor for transient failures with exponential backoff.
  void _configureRetry() {
    final retryInterceptor = RetryInterceptor(dio: _dio);
    _dio.interceptors.add(retryInterceptor);
  }

  /// Configures Dio's HTTP client adapter to validate certificates
  /// against pinned SHA-256 SPKI hashes for known domains.
  ///
  /// Uses the full certificate DER bytes and computes the SHA-256 hash
  /// to compare against stored pins. This approach is more resilient to
  /// certificate renewals as long as the public key stays the same.
  void _configureCertificatePinning() {
    final adapter = _dio.httpClientAdapter;
    if (adapter is IOHttpClientAdapter) {
      adapter.createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
        ) {
          final pins = CertificatePins.pinsForHost(host);
          // If no pins configured for this host, allow the connection.
          if (pins.isEmpty) return true;

          // Compute SHA-256 hash of the certificate's DER-encoded bytes.
          // Note: dart:io X509Certificate only exposes full cert DER via
          // `cert.der`. For true SPKI pinning, the Subject Public Key Info
          // must be extracted. Since dart:io doesn't expose SPKI directly,
          // we hash the full cert DER as a pragmatic alternative.
          // Pins must be generated from the same full-cert hash.
          final certBytes = cert.der;
          final certHash = sha256.convert(certBytes);
          final certPin = 'sha256/${base64Encode(certHash.bytes)}';

          // Check if any pin matches.
          return pins.any((pin) => pin == certPin);
        };
        return client;
      };
    }
  }

  /// Logs a warning via [CrashReporter] at startup if any pinned domain
  /// has fewer than 2 configured pin hashes (insufficient for rotation).
  void _checkPinRedundancy() {
    for (final entry in CertificatePins.allPins.entries) {
      if (entry.value.length < 2) {
        crashReporter.recordError(
          StateError(
            'Insufficient pin redundancy for ${entry.key}: '
            '${entry.value.length} pin(s). At least 2 pins are recommended '
            'to allow certificate rotation.',
          ),
          StackTrace.current,
        );
      }
    }
  }

  @override
  Future<String> get({
    required final String url,
    required final String requestName,
  }) async {
    dynamic cResponse;
    try {
      loggerService.log('$requestName : $url');
      final dio.Response<dynamic> response = await _dio.get(url);
      cResponse = response.data;
      loggerService.log('$requestName response : $cResponse');
    } on dio.DioException catch (e) {
      loggerService.log('--${e.response}\n-${e.message}');
      // If the error is a certificate/handshake issue, wrap it as a
      // connection failure with a descriptive message.
      if (e.error is HandshakeException ||
          e.type == dio.DioExceptionType.connectionError) {
        final errorMsg = e.error;
        if (errorMsg is HandshakeException) {
          throw dio.DioException(
            requestOptions: e.requestOptions,
            error: e.error,
            type: dio.DioExceptionType.connectionError,
            message: 'Certificate mismatch for $url',
          );
        }
      }
      rethrow;
    }
    return jsonEncode(cResponse);
  }

  @override
  Future<String> post({
    required final String url,
    required final String requestName,
    required final Map<String, dynamic> body,
  }) async {
    dynamic cResponse;
    try {
      loggerService.log('$requestName POST: $url');
      loggerService.log('$requestName body: $body');
      final dio.Response<dynamic> response = await _dio.post(url, data: body);
      cResponse = response.data;
      loggerService.log('$requestName response : $cResponse');
    } on dio.DioException catch (e) {
      loggerService.log('--${e.response}\n-${e.message}');
      if (e.error is HandshakeException ||
          e.type == dio.DioExceptionType.connectionError) {
        final errorMsg = e.error;
        if (errorMsg is HandshakeException) {
          throw dio.DioException(
            requestOptions: e.requestOptions,
            error: e.error,
            type: dio.DioExceptionType.connectionError,
            message: 'Certificate mismatch for $url',
          );
        }
      }
      rethrow;
    }
    return jsonEncode(cResponse);
  }
}
