import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

/// Abstract interface for debug logging.
///
/// Can be mocked independently in unit tests.
abstract class LoggerService {
  /// Logs a debug message when logging is enabled.
  void log(dynamic message);
}

/// Implementation that uses `dart:developer` log.
///
/// Only logs when [kDebugMode] is true (automatically disabled in release).
class LoggerServiceImpl implements LoggerService {
  const LoggerServiceImpl();

  @override
  void log(dynamic message) {
    if (kDebugMode) dev.log('$message');
  }
}
