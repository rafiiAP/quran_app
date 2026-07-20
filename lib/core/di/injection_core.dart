import 'package:get_it/get_it.dart';
import 'package:quran_app/core/cache/cache_service.dart';
import 'package:quran_app/core/cache/shared_preferences_cache_service.dart';
import 'package:quran_app/core/constants/color.dart';
import 'package:quran_app/core/constants/config.dart';
import 'package:quran_app/core/constants/image.dart';
import 'package:quran_app/core/network/http_client.dart';
import 'package:quran_app/core/network/main_http_client.dart';
import 'package:quran_app/core/router/app_router.dart';
import 'package:quran_app/core/services/connectivity_service.dart';
import 'package:quran_app/core/services/crash_reporter.dart';
import 'package:quran_app/core/services/datetime_service.dart';
import 'package:quran_app/core/services/firebase_crash_reporter.dart';
import 'package:quran_app/core/services/flutter_notification_service.dart';
import 'package:quran_app/core/services/location_service.dart';
import 'package:quran_app/core/services/logger_service.dart';
import 'package:quran_app/core/services/notification_service.dart';
import 'package:quran_app/core/services/permission_service.dart';
import 'package:quran_app/core/services/showcase_service.dart';
import 'package:quran_app/core/storage/database_helper.dart';
import 'package:quran_app/core/storage/local_storage_service.dart';
import 'package:quran_app/core/storage/shared_preferences_storage_service.dart';
import 'package:quran_app/core/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Registers all core/infrastructure dependencies.
Future<void> registerCoreDependencies(GetIt locator) async {
  // local storage — SharedPreferences requires async init
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  locator.registerLazySingleton<LocalStorageService>(
    () => SharedPreferencesStorageService(prefs: prefs),
  );

  // cache service — shares SharedPreferences instance
  locator.registerLazySingleton<CacheService>(
    () => SharedPreferencesCacheService(prefs: prefs),
  );

  // logger service
  locator.registerLazySingleton<LoggerService>(
    () => LoggerServiceImpl(appConfig: locator()),
  );

  // datetime service
  locator.registerLazySingleton<DatetimeService>(
    DatetimeServiceImpl.new,
  );

  // permission service
  locator.registerLazySingleton<PermissionService>(
    PermissionServiceImpl.new,
  );

  // showcase service
  locator.registerLazySingleton<ShowcaseService>(
    () => ShowcaseServiceImpl(storageService: locator()),
  );

  // notification service
  locator.registerLazySingleton<NotificationService>(
    FlutterNotificationService.new,
  );

  // location service
  locator.registerLazySingleton<LocationService>(
    LocationServiceImpl.new,
  );

  // connectivity service
  locator.registerLazySingleton<ConnectivityService>(
    ConnectivityServiceImpl.new,
  );

  // router
  locator.registerLazySingleton<AppRouter>(
    () => AppRouter(storageService: locator()),
  );

  // http client
  locator.registerLazySingleton<AppHttpClient>(
    () => MainHttpClient(
      crashReporter: locator(),
      loggerService: locator(),
    ),
  );

  // crash reporter
  locator.registerLazySingleton<CrashReporter>(FirebaseCrashReporter.new);

  // style
  locator.registerLazySingleton<MainStyle>(MainStyle.new);

  // color
  locator.registerLazySingleton<AppColorConfig>(AppColorConfig.new);

  // appconfig
  locator.registerLazySingleton<AppConfig>(AppConfig.new);

  // image
  locator.registerLazySingleton<MyImage>(MyImage.new);

  // database
  locator.registerLazySingleton<DatabaseHelper>(DatabaseHelper.new);
}
