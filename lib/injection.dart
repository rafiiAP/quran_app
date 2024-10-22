import 'package:get_it/get_it.dart';
import 'package:quran_app/data/repositories_impl/quran_repository_impl.dart';
import 'package:quran_app/domain/repositories/quran_repository.dart';

GetIt locator = GetIt.instance;

void setup() {
  // usecase
  // locator.registerLazySingleton<QuranUsecase>(() => QuranUsecase());

  // repository
  locator.registerLazySingleton<QuranRepository>(() => QuranRepositoryImpl());

  // data source
  // locator.registerLazySingleton<QuranDatasource>(() => QuranDatasource());
}
