/// Centralized API endpoint URLs.
///
/// Separated from [AppConfig] for single-responsibility:
/// this class only knows about remote API URLs.
class ApiEndpoints {
  const ApiEndpoints._();

  static const String surah = 'https://equran.id/api/v2/surat';
  static const String jadwalSholat = 'https://api.aladhan.com/v1/timings';
}
