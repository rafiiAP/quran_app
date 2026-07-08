/// Abstract crash reporter — dapat di-mock di unit test.
abstract class CrashReporter {
  Future<void> recordError(Object exception, StackTrace? stackTrace);
}
