/// Centralized route path constants.
///
/// Separated from [AppConfig] for single-responsibility.
/// All GoRouter paths should be referenced from here.
class RouteNames {
  const RouteNames._();

  static const String home = '/home';
  static const String started = '/started';
  static const String bookmark = '/bookmark';
  static const String jadwalSholat = '/jadwal-sholat';
  static const String detailSurah = '/detail-surah';
  static const String search = '/search';
}
