import 'package:get_it/get_it.dart';
import 'package:quran_app/core/constants/api_endpoints.dart';
import 'package:quran_app/features/detail_surah/data/datasources/detail_surah_datasource.dart';
import 'package:quran_app/features/detail_surah/data/datasources/detail_surah_local_datasource.dart';
import 'package:quran_app/features/detail_surah/data/datasources/detail_surah_local_datasource_impl.dart';
import 'package:quran_app/features/detail_surah/data/repositories/detail_surah_repository_impl.dart';
import 'package:quran_app/features/detail_surah/domain/repositories/detail_surah_repository.dart';
import 'package:quran_app/features/detail_surah/domain/usecases/get_detail_surah_usecase.dart';

/// Registers detail surah feature dependencies.
void registerDetailSurahDependencies(GetIt locator) {
  locator.registerLazySingleton<GetDetailSurahUseCase>(
    () => GetDetailSurahUseCase(locator()),
  );

  locator.registerLazySingleton<DetailSurahRepository>(
    () => DetailSurahRepositoryImpl(
      datasource: locator(),
      localDatasource: locator(),
      connectivityService: locator(),
    ),
  );

  locator.registerLazySingleton<DetailSurahDatasource>(
    () => DetailSurahDatasourceImpl(
      httpClient: locator(),
      crashReporter: locator(),
      baseUrl: ApiEndpoints.surah,
    ),
  );

  locator.registerLazySingleton<DetailSurahLocalDatasource>(
    () => DetailSurahLocalDatasourceImpl(cacheService: locator()),
  );
}
