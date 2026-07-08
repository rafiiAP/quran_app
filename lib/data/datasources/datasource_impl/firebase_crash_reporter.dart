import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:quran_app/data/datasources/crash_reporter.dart';

/// Concrete implementation yang mendelegasikan ke [FirebaseCrashlytics].
class FirebaseCrashReporter implements CrashReporter {
  @override
  Future<void> recordError(Object exception, StackTrace? stackTrace) {
    return FirebaseCrashlytics.instance.recordError(exception, stackTrace);
  }
}
