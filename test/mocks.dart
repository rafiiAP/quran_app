import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/cache/cache_service.dart';
import 'package:quran_app/core/network/http_client.dart';
import 'package:quran_app/core/services/connectivity_service.dart';
import 'package:quran_app/core/services/crash_reporter.dart';
import 'package:quran_app/core/usecases/save_bookmark_action.dart';
import 'package:quran_app/features/jadwal_sholat/data/datasources/jadwal_sholat_local_datasource.dart';
import 'package:quran_app/core/services/datetime_service.dart';
import 'package:quran_app/core/services/location_service.dart';
import 'package:quran_app/core/services/logger_service.dart';
import 'package:quran_app/core/services/notification_service.dart';
import 'package:quran_app/core/services/permission_service.dart';
import 'package:quran_app/core/services/showcase_service.dart';
import 'package:quran_app/core/storage/database_helper.dart';
import 'package:quran_app/core/storage/local_storage_service.dart';
import 'package:quran_app/features/bookmark/data/datasources/bookmark_local_datasource.dart';
import 'package:quran_app/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:quran_app/features/bookmark/domain/usecases/delete_bookmark_usecase.dart';
import 'package:quran_app/features/bookmark/domain/usecases/get_bookmarks_usecase.dart';
import 'package:quran_app/features/bookmark/domain/usecases/save_bookmark_usecase.dart';
import 'package:quran_app/features/detail_surah/data/datasources/detail_surah_local_datasource.dart';
import 'package:quran_app/features/detail_surah/domain/repositories/detail_surah_repository.dart';
import 'package:quran_app/features/detail_surah/domain/usecases/get_detail_surah_usecase.dart';
import 'package:quran_app/features/jadwal_sholat/data/datasources/jadwal_sholat_datasource.dart';
import 'package:quran_app/features/jadwal_sholat/domain/repositories/jadwal_sholat_repository.dart';
import 'package:quran_app/features/jadwal_sholat/domain/usecases/get_jadwal_sholat_usecase.dart';
import 'package:quran_app/features/surah/data/datasources/surah_datasource.dart';
import 'package:quran_app/features/surah/data/datasources/surah_local_datasource.dart';
import 'package:quran_app/features/surah/domain/repositories/surah_repository.dart';
import 'package:quran_app/features/surah/domain/usecases/get_surah_usecase.dart';

// Domain layer
class MockSurahRepository extends Mock implements SurahRepository {}

class MockDetailSurahRepository extends Mock implements DetailSurahRepository {}

class MockJadwalSholatRepository extends Mock
    implements JadwalSholatRepository {}

class MockBookmarkRepository extends Mock implements BookmarkRepository {}

class MockGetSurahUseCase extends Mock implements GetSurahUseCase {}

class MockGetDetailSurahUseCase extends Mock implements GetDetailSurahUseCase {}

class MockGetJadwalSholatUseCase extends Mock
    implements GetJadwalSholatUseCase {}

// Data layer
class MockSurahDatasource extends Mock implements SurahDatasource {}

class MockJadwalSholatDatasource extends Mock
    implements JadwalSholatDatasource {}

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

// Infrastructure
class MockAppHttpClient extends Mock implements AppHttpClient {}

class MockCrashReporter extends Mock implements CrashReporter {}

// Storage
class MockLocalStorageService extends Mock implements LocalStorageService {}

// Notifications
class MockNotificationService extends Mock implements NotificationService {}

// Services (extracted from MainFunction)
class MockLoggerService extends Mock implements LoggerService {}

class MockDatetimeService extends Mock implements DatetimeService {}

class MockPermissionService extends Mock implements PermissionService {}

class MockShowcaseService extends Mock implements ShowcaseService {}

// Location
class MockLocationService extends Mock implements LocationService {}

// Bookmark use cases
class MockGetBookmarksUseCase extends Mock implements GetBookmarksUseCase {}

class MockSaveBookmarkUseCase extends Mock implements SaveBookmarkUseCase {}

class MockSaveBookmarkAction extends Mock implements SaveBookmarkAction {}

class MockDeleteBookmarkUseCase extends Mock implements DeleteBookmarkUseCase {}

// Bookmark datasource
class MockBookmarkLocalDatasource extends Mock
    implements BookmarkLocalDatasource {}

// Cache
class MockCacheService extends Mock implements CacheService {}

class MockSurahLocalDatasource extends Mock implements SurahLocalDatasource {}

class MockDetailSurahLocalDatasource extends Mock
    implements DetailSurahLocalDatasource {}

// Connectivity
class MockConnectivityService extends Mock implements ConnectivityService {}

// Jadwal Sholat Local
class MockJadwalSholatLocalDatasource extends Mock
    implements JadwalSholatLocalDatasource {}
