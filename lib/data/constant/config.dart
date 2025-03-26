import 'package:quran_app/injection.dart';

AppConfig get config => locator<AppConfig>();

class AppConfig {
  String cUrlJadwalSholat =
      'https://api.aladhan.com/v1/timings/'; //01-03-2025?latitude=-6.9175&longitude=107.6191

  String cAppName = 'Component App';
  String cAppVersion = '1.0.0';

  bool lShowLog = true;

  int nAppVersion = 1;

  //---------cache-------------//
  String cacheNomorSurah = 'cacheNomorSurah';
  String cacheNomorAyat = 'cacheNomorAyat';
  String cacheNamaLatin = 'cacheNamaLatin';
  String cacheStarted = 'cacheStarted';
}
