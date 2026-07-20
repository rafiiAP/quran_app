/// Centralized cache/storage key constants.
///
/// Separated from [AppConfig] to avoid mixing concerns.
/// All SharedPreferences keys should be declared here.
class CacheKeys {
  const CacheKeys._();

  static const String nomorSurah = 'cacheNomorSurah';
  static const String nomorAyat = 'cacheNomorAyat';
  static const String namaLatin = 'cacheNamaLatin';
  static const String started = 'cacheStarted';
  static const String showCase = 'cacheShowCase';
  static const String showCaseDetail = 'cacheShowCaseDetail';
  static const String showCaseBottomDetail = 'cacheShowCaseBottomDetail';

  /// Returns the alarm storage key for a given prayer title.
  static String alarmKey(String title) => 'alarm_$title';
}
