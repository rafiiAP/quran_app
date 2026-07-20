import 'package:get_it/get_it.dart';
import 'package:quran_app/core/constants/api_endpoints.dart';
import 'package:quran_app/features/jadwal_sholat/data/datasources/jadwal_sholat_datasource.dart';
import 'package:quran_app/features/jadwal_sholat/data/datasources/jadwal_sholat_local_datasource.dart';
import 'package:quran_app/features/jadwal_sholat/data/datasources/jadwal_sholat_local_datasource_impl.dart';
import 'package:quran_app/features/jadwal_sholat/data/repositories/jadwal_sholat_repository_impl.dart';
import 'package:quran_app/features/jadwal_sholat/domain/repositories/jadwal_sholat_repository.dart';
import 'package:quran_app/features/jadwal_sholat/domain/usecases/get_jadwal_sholat_usecase.dart';

/// Registers jadwal sholat feature dependencies.
void registerJadwalSholatDependencies(GetIt locator) {
  locator.registerLazySingleton<GetJadwalSholatUseCase>(
    () => GetJadwalSholatUseCase(locator()),
  );

  locator.registerLazySingleton<JadwalSholatLocalDatasource>(
    () => JadwalSholatLocalDatasourceImpl(cacheService: locator()),
  );

  locator.registerLazySingleton<JadwalSholatRepository>(
    () => JadwalSholatRepositoryImpl(
      datasource: locator(),
      localDatasource: locator(),
      connectivityService: locator(),
    ),
  );

  locator.registerLazySingleton<JadwalSholatDatasource>(
    () => JadwalSholatDatasourceImpl(
      httpClient: locator(),
      crashReporter: locator(),
      baseUrl: ApiEndpoints.jadwalSholat,
    ),
  );
}
