import 'package:get_it/get_it.dart';
import 'package:quran_app/core/usecases/save_bookmark_action.dart';
import 'package:quran_app/features/bookmark/data/datasources/bookmark_local_datasource.dart';
import 'package:quran_app/features/bookmark/data/datasources/bookmark_local_datasource_impl.dart';
import 'package:quran_app/features/bookmark/data/repositories/bookmark_repository_impl.dart';
import 'package:quran_app/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:quran_app/features/bookmark/domain/usecases/delete_bookmark_usecase.dart';
import 'package:quran_app/features/bookmark/domain/usecases/get_bookmarks_usecase.dart';
import 'package:quran_app/features/bookmark/domain/usecases/save_bookmark_usecase.dart';

/// Registers bookmark feature dependencies.
void registerBookmarkDependencies(GetIt locator) {
  // Datasource
  locator.registerLazySingleton<BookmarkLocalDatasource>(
    () => BookmarkLocalDatasourceImpl(databaseHelper: locator()),
  );

  // Repository
  locator.registerLazySingleton<BookmarkRepository>(
    () => BookmarkRepositoryImpl(datasource: locator()),
  );

  // Use cases
  locator.registerLazySingleton<GetBookmarksUseCase>(
    () => GetBookmarksUseCase(locator()),
  );
  locator.registerLazySingleton<SaveBookmarkUseCase>(
    () => SaveBookmarkUseCase(locator()),
  );
  locator.registerLazySingleton<DeleteBookmarkUseCase>(
    () => DeleteBookmarkUseCase(locator()),
  );

  // Core-level abstract — allows other features to depend on the contract
  // without importing from the bookmark feature.
  locator.registerLazySingleton<SaveBookmarkAction>(
    () => locator<SaveBookmarkUseCase>(),
  );
}
