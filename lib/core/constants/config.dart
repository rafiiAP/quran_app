import 'package:flutter/foundation.dart';
import 'package:quran_app/core/constants/api_endpoints.dart';
import 'package:quran_app/core/constants/cache_keys.dart';
import 'package:quran_app/core/constants/route_names.dart';
import 'package:quran_app/core/di/injection.dart';

AppConfig get config => locator<AppConfig>();

/// App-wide configuration.
///
/// Delegates to focused constant classes:
/// - [ApiEndpoints] — API URLs
/// - [CacheKeys] — local storage keys
/// - [RouteNames] — GoRouter path constants
///
/// This class provides instance-level access (via DI) for legacy compatibility.
/// New code should prefer the dedicated constant classes directly.
class AppConfig {
  //---------API URLs (delegated to ApiEndpoints)-------------//
  final String cUrlSurah = ApiEndpoints.surah;
  final String cUrlJadwalSholat = ApiEndpoints.jadwalSholat;

  final String cAppName = 'Component App';
  final String cAppVersion = '1.0.0';

  /// Whether to log debug messages. Defaults to [kDebugMode] so logs
  /// are automatically disabled in release builds.
  final bool lShowLog = kDebugMode;

  final int nAppVersion = 1;

  //---------cache keys (delegated to CacheKeys)-------------//
  final String cacheNomorSurah = CacheKeys.nomorSurah;
  final String cacheNomorAyat = CacheKeys.nomorAyat;
  final String cacheNamaLatin = CacheKeys.namaLatin;
  final String cacheStarted = CacheKeys.started;
  final String cacheShowCase = CacheKeys.showCase;
  final String cacheShowCaseDetail = CacheKeys.showCaseDetail;
  final String cacheShowCaseBottomDetail = CacheKeys.showCaseBottomDetail;

  /// Returns the alarm storage key for a given prayer title.
  String alarmKey(String title) => CacheKeys.alarmKey(title);

  //---------route paths (delegated to RouteNames)-------------//
  static const String routeHome = RouteNames.home;
  static const String routeStarted = RouteNames.started;
  static const String routeBookmark = RouteNames.bookmark;
  static const String routeJadwalSholat = RouteNames.jadwalSholat;
  static const String routeDetailSurah = RouteNames.detailSurah;
  static const String routeSearch = RouteNames.search;
}
