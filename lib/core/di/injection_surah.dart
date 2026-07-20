import 'package:get_it/get_it.dart';
import 'package:quran_app/core/constants/config.dart';
import 'package:quran_app/features/surah/data/datasources/surah_datasource.dart';
import 'package:quran_app/features/surah/data/datasources/surah_local_datasource.dart';
import 'package:quran_app/features/surah/data/repositories/surah_repository_impl.dart';
import 'package:quran_app/features/surah/domain/repositories/surah_repository.dart';
import 'package:quran_app/features/surah/domain/usecases/get_surah_usecase.dart';

/// Registers surah feature dependencies.
void registerSurahDependencies(GetIt locator) {
  locator.registerLazySingleton<GetSurahUseCase>(
    () => GetSurahUseCase(locator()),
  );

  locator.registerLazySingleton<SurahRepository>(
    () => SurahRepositoryImpl(
      datasource: locator(),
      localDatasource: locator(),
      connectivityService: locator(),
    ),
  );

  locator.registerLazySingleton<SurahDatasource>(
    () => SurahDatasourceImpl(
      httpClient: locator(),
      crashReporter: locator(),
      baseUrl: locator<AppConfig>().cUrlSurah,
    ),
  );

  locator.registerLazySingleton<SurahLocalDatasource>(
    () => SurahLocalDatasourceImpl(cacheService: locator()),
  );
}
