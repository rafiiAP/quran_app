import 'package:quran_app/core/di/injection.dart';

AppConfig get config => locator<AppConfig>();

class AppConfig {
  //---------API URLs-------------//
  final String cUrlSurah = 'https://equran.id/api/v2/surat';
  final String cUrlJadwalSholat = 'https://api.aladhan.com/v1/timings';

  final String cAppName = 'Component App';
  final String cAppVersion = '1.0.0';

  final bool lShowLog = true;

  final int nAppVersion = 1;

  //---------cache keys-------------//
  final String cacheNomorSurah = 'cacheNomorSurah';
  final String cacheNomorAyat = 'cacheNomorAyat';
  final String cacheNamaLatin = 'cacheNamaLatin';
  final String cacheStarted = 'cacheStarted';
  final String cacheShowCase = 'cacheShowCase';
  final String cacheShowCaseDetail = 'cacheShowCaseDetail';
  final String cacheShowCaseBottomDetail = 'cacheShowCaseBottomDetail';

  /// Returns the alarm storage key for a given prayer title.
  String alarmKey(String title) => 'alarm_$title';

  //---------route paths-------------//
  static const String routeHome = '/home';
  static const String routeStarted = '/started';
  static const String routeBookmark = '/bookmark';
  static const String routeJadwalSholat = '/jadwal-sholat';
  static const String routeDetailSurah = '/detail-surah';
  static const String routeSearch = '/search';
}
