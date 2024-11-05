class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  AppConfig._internal();

  factory AppConfig() {
    return _instance;
  }

  static const String cAppName = 'Component App';
  static const String cAppVersion = '1.0.0';

  static const bool lShowLog = true;

  static const int nAppVersion = 1;

  //---------cache-------------//
  static const String cacheNomorAyat = 'cacheNomorAyat';
  static const String cacheNamaLatin = 'cacheNamaLatin';
  static const String cacheStarted = 'cacheStarted';
}
