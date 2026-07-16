import 'package:get_it/get_it.dart';
import 'package:quran_app/core/constants/color.dart';
import 'package:quran_app/core/constants/config.dart';
import 'package:quran_app/core/constants/image.dart';
import 'package:quran_app/core/network/http_client.dart';
import 'package:quran_app/core/network/main_http_client.dart';
import 'package:quran_app/core/router/app_router.dart';
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
import 'package:quran_app/core/widgets/app_bottomsheet.dart';
import 'package:quran_app/core/widgets/app_button.dart';
import 'package:quran_app/core/widgets/app_input.dart';
import 'package:quran_app/core/widgets/app_padding.dart';
import 'package:quran_app/core/widgets/app_shimmer.dart';
import 'package:quran_app/core/widgets/app_text.dart';
import 'package:quran_app/features/bookmark/data/repositories/bookmark_repository_impl.dart';
import 'package:quran_app/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:quran_app/features/bookmark/domain/usecases/delete_bookmark_usecase.dart';
import 'package:quran_app/features/bookmark/domain/usecases/get_bookmarks_usecase.dart';
import 'package:quran_app/features/bookmark/domain/usecases/save_bookmark_usecase.dart';
import 'package:quran_app/features/detail_surah/data/datasources/detail_surah_datasource.dart';
import 'package:quran_app/features/detail_surah/data/repositories/detail_surah_repository_impl.dart';
import 'package:quran_app/features/detail_surah/domain/repositories/detail_surah_repository.dart';
import 'package:quran_app/features/detail_surah/domain/usecases/get_detail_surah_usecase.dart';
import 'package:quran_app/features/jadwal_sholat/data/datasources/jadwal_sholat_datasource.dart';
import 'package:quran_app/features/jadwal_sholat/data/repositories/jadwal_sholat_repository_impl.dart';
import 'package:quran_app/features/jadwal_sholat/domain/repositories/jadwal_sholat_repository.dart';
import 'package:quran_app/features/jadwal_sholat/domain/usecases/get_jadwal_sholat_usecase.dart';
import 'package:quran_app/features/surah/data/datasources/surah_datasource.dart';
import 'package:quran_app/features/surah/data/repositories/surah_repository_impl.dart';
import 'package:quran_app/features/surah/domain/repositories/surah_repository.dart';
import 'package:quran_app/features/surah/domain/usecases/get_surah_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt locator = GetIt.instance;

Future<void> setup() async {
  // local storage — SharedPreferences requires async init
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  locator.registerLazySingleton<LocalStorageService>(
    () => SharedPreferencesStorageService(prefs: prefs),
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

  // router
  locator.registerLazySingleton<AppRouter>(
    () => AppRouter(storageService: locator()),
  );

  // per-feature usecases
  locator.registerLazySingleton<GetSurahUseCase>(
    () => GetSurahUseCase(locator()),
  );
  locator.registerLazySingleton<GetDetailSurahUseCase>(
    () => GetDetailSurahUseCase(locator()),
  );
  locator.registerLazySingleton<GetJadwalSholatUseCase>(
    () => GetJadwalSholatUseCase(locator()),
  );
  locator.registerLazySingleton<GetBookmarksUseCase>(
    () => GetBookmarksUseCase(locator()),
  );
  locator.registerLazySingleton<SaveBookmarkUseCase>(
    () => SaveBookmarkUseCase(locator()),
  );
  locator.registerLazySingleton<DeleteBookmarkUseCase>(
    () => DeleteBookmarkUseCase(locator()),
  );

  // per-feature repositories
  locator.registerLazySingleton<SurahRepository>(
    () => SurahRepositoryImpl(datasource: locator()),
  );
  locator.registerLazySingleton<DetailSurahRepository>(
    () => DetailSurahRepositoryImpl(datasource: locator()),
  );
  locator.registerLazySingleton<JadwalSholatRepository>(
    () => JadwalSholatRepositoryImpl(datasource: locator()),
  );
  locator.registerLazySingleton<BookmarkRepository>(
    () => BookmarkRepositoryImpl(databaseHelper: locator()),
  );

  // per-feature datasources
  locator.registerLazySingleton<SurahDatasource>(
    () => SurahDatasourceImpl(
      httpClient: locator(),
      crashReporter: locator(),
      baseUrl: locator<AppConfig>().cUrlSurah,
    ),
  );
  locator.registerLazySingleton<DetailSurahDatasource>(
    () => DetailSurahDatasourceImpl(
      httpClient: locator(),
      crashReporter: locator(),
      baseUrl: locator<AppConfig>().cUrlSurah,
    ),
  );
  locator.registerLazySingleton<JadwalSholatDatasource>(
    () => JadwalSholatDatasourceImpl(
      httpClient: locator(),
      crashReporter: locator(),
      baseUrl: locator<AppConfig>().cUrlJadwalSholat,
    ),
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

  // widget utilities (standalone, each with abstract interface)
  locator.registerLazySingleton<AppTextFactory>(AppTextFactoryImpl.new);
  locator.registerLazySingleton<AppButtonFactory>(AppButtonFactoryImpl.new);
  locator.registerLazySingleton<AppInputFactory>(AppInputFactoryImpl.new);
  locator.registerLazySingleton<AppBottomsheetFactory>(
    AppBottomsheetFactoryImpl.new,
  );
  locator.registerLazySingleton<AppShimmerFactory>(AppShimmerFactoryImpl.new);
  locator.registerLazySingleton<AppPaddingFactory>(AppPaddingFactoryImpl.new);

  // color
  locator.registerLazySingleton<AppColorConfig>(AppColorConfig.new);

  // appconfig
  locator.registerLazySingleton<AppConfig>(AppConfig.new);

  // image
  locator.registerLazySingleton<MyImage>(MyImage.new);

  // database
  locator.registerLazySingleton<DatabaseHelper>(DatabaseHelper.new);
}
