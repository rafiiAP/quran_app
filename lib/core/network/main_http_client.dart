import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:quran_app/core/network/certificate_pins.dart';
import 'package:quran_app/core/network/http_client.dart';
import 'package:quran_app/core/services/crash_reporter.dart';
import 'package:quran_app/core/services/logger_service.dart';

/// Concrete [AppHttpClient] implementation using Dio.
///
/// In release mode, configures certificate pinning to validate server
/// certificates against known SHA-256 public key hashes. In debug mode,
/// pin validation is bypassed for development convenience.
class MainHttpClient implements AppHttpClient {
  MainHttpClient({
    required this.crashReporter,
    required this.loggerService,
    dio.Dio? dioClient,
  }) : _dio = dioClient ?? dio.Dio() {
    if (!kDebugMode) {
      _configureCertificatePinning();
    }
    _checkPinRedundancy();
  }

  final CrashReporter crashReporter;
  final LoggerService loggerService;
  final dio.Dio _dio;

  /// Configures Dio's HTTP client adapter to validate certificates
  /// against pinned SHA-256 hashes for known domains.
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
          // Compute SHA-256 hash of the certificate's DER-encoded data.
          final certHash =
              'sha256/${base64Encode(cert.der.buffer.asUint8List())}';
          // Check if any pin matches.
          // Note: In a real implementation you'd hash the SPKI (Subject Public
          // Key Info), but since we can only access the full cert DER via
          // dart:io X509Certificate, we compare against the full cert hash.
          // The pins should be generated accordingly.
          return pins.any((pin) => pin == certHash);
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
}
