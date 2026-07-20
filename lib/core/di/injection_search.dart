import 'package:get_it/get_it.dart';
import 'package:quran_app/features/search/domain/usecases/search_surah_usecase.dart';

/// Registers search feature dependencies.
void registerSearchDependencies(GetIt locator) {
  locator.registerLazySingleton<SearchSurahUseCase>(
    () => const SearchSurahUseCase(),
  );
}
