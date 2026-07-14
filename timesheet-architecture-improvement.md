# Timesheet — Architecture Improvement (79 Tasks)

**Total Estimasi: 55 jam**

---

## Phase 1 — Foundation (4 jam)

| Task | Aktivitas | Durasi |
|------|-----------|--------|
| 1 | Konfigurasi analysis_options.yaml — tambah strict-casts, strict-raw-types, strict-inference; enable avoid_print, prefer_single_quotes, require_trailing_commas, prefer_const_constructors, avoid_dynamic_calls; exclude *.freezed.dart, *.g.dart, firebase_options.dart | 0.5j |
| 2 | Fix seluruh lint warnings di lib/ agar pass flutter analyze zero errors — resolve prefer_const_constructors, require_trailing_commas, avoid_dynamic_calls, prefer_single_quotes di semua file Dart | 2j |
| 3 | Buat .github/dependabot.yml — konfigurasi pub ecosystem, schedule weekly, group minor+patch updates dalam 1 PR, target branch develop | 0.5j |
| 4 | Buat .github/workflows/ci.yml — pipeline lengkap: checkout, flutter pub get, flutter analyze, flutter test --coverage, coverage gate ≥90%, trigger push main + PR main, timeout 15 menit | 1j |

---

## Phase 2 — Structural Refactor (16 jam)

| Task | Aktivitas | Durasi |
|------|-----------|--------|
| 5 | Buat folder structure lib/core/ — subdirectory: di/, error/, network/, router/, services/, storage/, widgets/, constants/ | 0.5j |
| 6 | Pindahkan lib/data/constant/ (color, config, enum, image) ke lib/core/constants/. Update seluruh import di lib/ dan test/ | 1j |
| 7 | Pindahkan local_storage_service.dart dan shared_preferences_storage_service.dart ke lib/core/storage/. Update imports | 0.5j |
| 8 | Pindahkan http_client.dart ke lib/core/network/ dan main_http_client.dart ke lib/core/network/. Update seluruh import reference | 0.5j |
| 9 | Pindahkan crash_reporter.dart (abstract + Firebase impl) ke lib/core/services/crash_reporter.dart. Update imports | 0.5j |
| 10 | Pindahkan notification_service.dart (abstract + Flutter impl) ke lib/core/services/notification_service.dart. Update imports | 0.5j |
| 11 | Extract PermissionService abstract + impl dari components/function/permission_service.dart → lib/core/services/permission_service.dart. Standalone injectable, no mixin | 1j |
| 12 | Extract DatetimeService abstract + impl dari components/function/datetime_com.dart → lib/core/services/datetime_service.dart. Standalone injectable | 0.5j |
| 13 | Extract ShowcaseService abstract + impl dari MainFunction.showCase → lib/core/services/showcase_service.dart. Inject LocalStorageService via constructor | 1j |
| 14 | Extract LoggerService abstract + impl dari MainFunction.showLog → lib/core/services/logger_service.dart. Standalone injectable | 0.5j |
| 15 | Buat standalone widget classes di lib/core/widgets/: AppText (body+title), AppButton (elevated, outlined, text), AppInput, AppBottomsheet, AppShimmer, AppPadding — replace mixin pattern | 2j |
| 16 | Hapus lib/components/ folder sepenuhnya — delete main_function.dart, main_widget.dart, api_service.dart, semua part files. Hapus global getter C dan W. Update injection.dart register services baru | 1j |
| 17 | Buat folder structure lib/features/ — surah/, detail_surah/, jadwal_sholat/, bookmark/, search/, dashboard/ masing-masing dengan domain/, data/, presentation/ | 0.5j |
| 18 | Pindahkan domain entities ke feature folders: surah_entity → features/surah/domain/entities/, detail_entity → features/detail_surah/, jadwal_sholat_entity → features/jadwal_sholat/ | 0.5j |
| 19 | Pindahkan data models ke feature folders: surah_model, detail_model, jadwal_sholat_model, bookmark_model, set_notif_model ke masing-masing features/*/data/models/. Update imports | 1j |
| 20 | Pindahkan presentation pages ke feature folders: home_page, detail_surah_page, jadwal_sholat_page, bookmark_page, search_page, dashboard_page, started_page. Update imports | 1j |
| 21 | Pindahkan cubit folders ke feature folders: get_surah_cubit → features/surah/, detail_surah_cubit → features/detail_surah/, jadwal_sholat cubits, bookmark_cubit, search_cubit, dashboard+home_cubit | 1j |
| 22 | Pindahkan injection.dart → lib/core/di/injection.dart, DatabaseHelper → lib/core/storage/database_helper.dart. Update main.dart imports | 0.5j |
| 23 | Update seluruh view files — ganti C.* dan W.* calls dengan standalone widget classes (AppText, AppButton, AppShimmer) dan injected services via context.read<T>() | 2j |
| 24 | Pindahkan Failure class hierarchy (ConnectionFailure, ServerFailure, ResponseFailure) dari remote_repository.dart ke lib/core/error/failure.dart sebagai shared domain types | 0.5j |
| 25 | Update seluruh test imports ke lokasi file baru. Run flutter test, verify semua 226 tests pass tanpa perubahan logic | 1j |

---

## Phase 3 — Domain/Data Layer (12 jam)

| Task | Aktivitas | Durasi |
|------|-----------|--------|
| 26 | Tambah fpdart ke pubspec.yaml dependencies, hapus dartz, run flutter pub get. Verify resolve tanpa conflict | 0.5j |
| 27 | Migrasi dartz → fpdart di seluruh lib/ dan test/: ganti import, replace Either.fold() → Either.match(), replace right()/left() → Right()/Left(). Verify semua tests pass | 2j |
| 28 | Buat lib/core/error/data_exception.dart — DataFailureType enum (connection, server, parsing) dan DataException class dengan type + message property | 0.5j |
| 29 | Buat SurahRepository abstract class di features/surah/domain/repositories/ — method getSurah() dan getDetailSurah() return Future<Either<Failure, T>> | 0.5j |
| 30 | Buat JadwalSholatRepository abstract class di features/jadwal_sholat/domain/repositories/ — method getJadwalSholat() return Future<Either<Failure, JadwalSholatEntity>> | 0.5j |
| 31 | Buat GetSurahUseCase di features/surah/domain/usecases/ — single call() method, inject SurahRepository via constructor, delegate ke getSurah() | 0.5j |
| 32 | Buat GetDetailSurahUseCase di features/detail_surah/domain/usecases/ — single call({required int nomor}), inject SurahRepository, delegate ke getDetailSurah() | 0.5j |
| 33 | Buat GetJadwalSholatUseCase di features/jadwal_sholat/domain/usecases/ — single call({latitude, longitude, date}), inject JadwalSholatRepository | 0.5j |
| 34 | Hapus file lama: lib/domain/use_case/remote_usecase.dart dan lib/domain/repositories/remote_repository.dart (Failure sudah dipindah di task 24) | 0.5j |
| 35 | Buat SurahDatasource abstract + SurahDatasourceImpl di features/surah/data/datasources/ — handle equran.id API, catch DioException → throw DataException, report ke CrashReporter | 1j |
| 36 | Buat JadwalSholatDatasource abstract + JadwalSholatDatasourceImpl di features/jadwal_sholat/data/datasources/ — handle aladhan.com API dengan DataException error pattern | 1j |
| 37 | Hapus file lama: lib/data/datasources/remote_datasource/remote_datasource.dart dan RemoteDatasourceImpl | 0.5j |
| 38 | Buat SurahRepositoryImpl di features/surah/data/repositories/ — catch DataException, map ke Failure via _mapToFailure(). Zero Dio imports | 1j |
| 39 | Buat JadwalSholatRepositoryImpl di features/jadwal_sholat/data/repositories/ — same DataException→Failure mapping. Zero Dio imports | 0.5j |
| 40 | Update lib/core/di/injection.dart — register SurahDatasource, JadwalSholatDatasource, SurahRepository, JadwalSholatRepository, GetSurahUseCase, GetDetailSurahUseCase, GetJadwalSholatUseCase. Hapus registrasi lama | 0.5j |
| 41 | Update GetSurahCubit — inject GetSurahUseCase (bukan RemoteUsecase), ganti result.fold() → result.match() | 0.5j |
| 42 | Update DetailSurahCubit — inject GetDetailSurahUseCase, ganti fold → match | 0.5j |
| 43 | Update JadwalSholatCubit — inject GetJadwalSholatUseCase, ganti fold → match | 0.5j |
| 44 | Update test/mocks.dart dan seluruh test files — buat MockSurahRepository, MockJadwalSholatRepository, MockGetSurahUseCase, MockGetDetailSurahUseCase, MockGetJadwalSholatUseCase. Verify tests pass | 1.5j |
| 45 | Tulis unit tests untuk GetSurahUseCase, GetDetailSurahUseCase, GetJadwalSholatUseCase — verify delegation ke repository, mock repository return Left/Right | 1j |
| 46 | Tulis unit tests untuk SurahDatasourceImpl dan JadwalSholatDatasourceImpl — mock AppHttpClient, verify DataException thrown on DioException, verify CrashReporter called | 1j |
| 47 | Tulis unit tests untuk SurahRepositoryImpl dan JadwalSholatRepositoryImpl — mock datasource, verify DataException(connection) → ConnectionFailure, DataException(server) → ServerFailure | 1j |

---

## Phase 4 — Presentation Layer (8 jam)

| Task | Aktivitas | Durasi |
|------|-----------|--------|
| 48 | Buat modular route files: dashboard_routes.dart (ShellRoute + /home, /bookmark, /jadwal-sholat), detail_surah_routes.dart, search_routes.dart, onboarding route (/started). Export List<RouteBase> | 1.5j |
| 49 | Refactor lib/core/router/app_router.dart — compose routes via spread operator dari feature route modules. Pertahankan redirect guard evaluateRedirect() | 0.5j |
| 50 | Impl safe path parsing di detail_surah_routes.dart: int.tryParse untuk nomor (redirect /home jika null, log via CrashReporter), int.tryParse untuk ayat query param (null = no scroll) | 0.5j |
| 51 | Tambah scoped MultiBlocProvider di detail_surah_routes.dart route builder — create DetailSurahCubit + DetailSurahPageCubit di route level, auto-dispose on pop | 0.5j |
| 52 | Refactor JadwalSholatPage — wrap content dengan scoped MultiBlocProvider di dalam page widget (JadwalSholatCubit + JadwalSholatPageCubit), karena ShellRoute child persistent | 1j |
| 53 | Hapus DetailSurahCubit, DetailSurahPageCubit, JadwalSholatCubit, JadwalSholatPageCubit dari global MultiBlocProvider di main.dart. Sisakan hanya app-wide cubits | 0.5j |
| 54 | Tambah locationError dan locationPermissionError states ke JadwalSholatPageState freezed. Tambah _retryCount + retryInit() method. Max 3 retries → permanent error | 1j |
| 55 | Update JadwalSholatPage view — handle locationError (tampilkan pesan + tombol retry), locationPermissionError (pesan cek settings). Run build_runner regenerate freezed | 1j |
| 56 | Run dart run build_runner build --delete-conflicting-outputs untuk regenerate semua .freezed.dart setelah state changes | 0.5j |
| 57 | Tulis unit tests GPS retry: verify locationError emitted retry 1-2, locationPermissionError pada retry 3, _retryCount reset pada success | 1j |
| 58 | Tulis unit tests safe parsing: invalid nomor → redirect /home + CrashReporter called, invalid ayat → indexTandai null, valid params → page rendered | 0.5j |
| 59 | Run existing app_router_test.dart — verify redirect guard tests masih pass setelah modularisasi router | 0.5j |

---

## Phase 5 — Quality & Security (7 jam)

| Task | Aktivitas | Durasi |
|------|-----------|--------|
| 60 | Buat lib/core/utils/model_validators.dart — function requireField<T>(json, fieldName) throw FormatException jika null/missing/wrong-type dengan message berisi field name | 0.5j |
| 61 | Tambah input validation ke SurahModel.fromMap dan SurahaDioModel.fromMap — requireField untuk semua required fields (nomor, nama, namaLatin, jumlahAyat, tempatTurun, arti, deskripsi, audioFull) | 1j |
| 62 | Tambah input validation ke DetailModel.fromMap, AyatDetailModel.fromMap, ResponseDetailModel.fromMap — requireField + nested list/map validation | 1j |
| 63 | Tambah input validation ke JadwalSholatModel.fromMap dan wrapper models (JadwalSholatDioModel, JadwalSholatDataModel) — requireField untuk semua prayer time fields | 0.5j |
| 64 | Tulis property-based tests model round-trip: 100 iterasi random valid map → fromMap → toMap → fromMap, assert Equatable equality. Cover SurahModel, DetailModel, JadwalSholatModel | 1j |
| 65 | Tulis property-based tests model validation: 100 iterasi random null/wrong-type field → fromMap throws FormatException, assert message contains field name | 1j |
| 66 | Buat lib/core/network/certificate_pins.dart — SHA-256 public key hash constants untuk equran.id (2 pins) dan api.aladhan.com (2 pins). Ambil dari server certificates | 0.5j |
| 67 | Update MainHttpClient — terima CrashReporter via constructor, configure Dio certificate pinning via IOHttpClientAdapter.createHttpClient + badCertificateCallback. Bypass jika kDebugMode. Check pin redundancy | 1j |
| 68 | Update injection.dart — pass CrashReporter ke MainHttpClient constructor registration | 0.5j |
| 69 | Tulis unit tests certificate pinning: verify reject on mismatch (throw DataException), verify bypass di kDebugMode, verify redundancy warning logged via CrashReporter | 1j |

---

## Phase 6 — Testing (8 jam)

| Task | Aktivitas | Durasi |
|------|-----------|--------|
| 70 | Buat widget test HomePage: 3 cases — loading (shimmer visible), success (surah list items rendered), tap surah item triggers HomeCubit.getDetailSurah(). Mock cubits via mocktail | 1.5j |
| 71 | Buat widget test DetailSurahPage: 3 cases — loading (CircularProgressIndicator), success (ayat teks arab + latin rendered), error (message + retry button visible) | 1.5j |
| 72 | Buat widget test JadwalSholatPage: 3 cases — loading state, loaded (prayer time entries visible), locationError (retry button, tap triggers retryInit) | 1.5j |
| 73 | Buat widget test BookmarkPage: 3 cases — loading, loaded (bookmark cards displayed), tap delete triggers BookmarkCubit.deleteBookmark() verified via mocktail | 1j |
| 74 | Buat widget test SearchPage: 3 cases — input field present, typing triggers SearchCubit filter, results list rendered on success state | 1j |
| 75 | Buat integration test navigation flow: pump full app MaterialApp.router, verify HomePage visible, tap surah → DetailSurahPage visible, pop back → HomePage visible | 1.5j |
| 76 | Update coverage_report.sh — hapus lib/presentation/view/* dari exclusion list, update paths ke feature-based structure. Verify coverage reported untuk page files | 0.5j |
| 77 | Tulis property-based test fpdart Either: 100 iterasi — Left(failure).match() invokes left callback, Right(data).match() invokes right callback. Verify type preservation | 0.5j |
| 78 | Tulis property-based test error mapping chain: 100 iterasi — DataException(connection) → ConnectionFailure, DataException(server) → ServerFailure, DataException(parsing) → ServerFailure | 0.5j |
| 79 | Final verification: run flutter test (all pass), flutter analyze (zero issues), coverage report (≥90%). Commit final state | 0.5j |

---

## Ringkasan per Phase

| Phase | Jumlah Tasks | Total Jam |
|-------|-------------|-----------|
| 1 — Foundation | 4 | 4j |
| 2 — Structural Refactor | 21 | 16j |
| 3 — Domain/Data Layer | 22 | 12j |
| 4 — Presentation Layer | 12 | 8j |
| 5 — Quality & Security | 10 | 7j |
| 6 — Testing | 10 | 8j |
| **TOTAL** | **79** | **55j** |

---

## Estimasi Hari Kerja

- 8 jam/hari → **~7 hari kerja**
- 6 jam/hari (realtime + meeting) → **~9-10 hari kerja**
- 4 jam/hari (part-time) → **~14 hari kerja**
