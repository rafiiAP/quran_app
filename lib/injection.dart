import 'package:get_it/get_it.dart';
import 'package:quran_app/data/datasources/quran/quran_datasource.dart';
import 'package:quran_app/data/repositories_impl/quran_repository_impl.dart';
import 'package:quran_app/domain/repositories/quran_repository.dart';
import 'package:quran_app/domain/use_case/quran_usecase.dart';

GetIt locator = GetIt.instance;

void setup() {
  // usecase
  locator.registerLazySingleton(() => QuranUsecase(locator()));

  // repository
  locator.registerLazySingleton<QuranRepository>(() => QuranRepositoryImpl(quranDatasource: locator()));

  // data source
  locator.registerLazySingleton<QuranDatasource>(() => QuranDatasourceImpl());
}
