import 'package:quran_app/core/di/injection.dart';

AppConfig get config => locator<AppConfig>();

class AppConfig {
  //---------API URLs-------------//
  String cUrlSurah = 'https://equran.id/api/v2/surat';
  String cUrlJadwalSholat = 'https://api.aladhan.com/v1/timings';

  String cAppName = 'Component App';
  String cAppVersion = '1.0.0';

  bool lShowLog = true;

  int nAppVersion = 1;

  //---------cache keys-------------//
  String cacheNomorSurah = 'cacheNomorSurah';
  String cacheNomorAyat = 'cacheNomorAyat';
  String cacheNamaLatin = 'cacheNamaLatin';
  String cacheStarted = 'cacheStarted';
  String cacheShowCase = 'cacheShowCase';
  String cacheShowCaseDetail = 'cacheShowCaseDetail';
  String cacheShowCaseBottomDetail = 'cacheShowCaseBottomDetail';

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
