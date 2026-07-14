import 'dart:developer' as dev;

import 'package:quran_app/core/constants/config.dart';

/// Abstract interface for debug logging.
///
/// Can be mocked independently in unit tests.
abstract class LoggerService {
  /// Logs a debug message when logging is enabled.
  void log(dynamic message);
}

/// Implementation that uses `dart:developer` log.
///
/// Only logs when [AppConfig.lShowLog] is true.
class LoggerServiceImpl implements LoggerService {
  LoggerServiceImpl({required this.appConfig});

  final AppConfig appConfig;

  @override
  void log(dynamic message) {
    if (appConfig.lShowLog) dev.log('$message');
  }
}
