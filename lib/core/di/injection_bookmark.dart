import 'package:get_it/get_it.dart';
import 'package:quran_app/features/bookmark/data/repositories/bookmark_repository_impl.dart';
import 'package:quran_app/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:quran_app/features/bookmark/domain/usecases/delete_bookmark_usecase.dart';
import 'package:quran_app/features/bookmark/domain/usecases/get_bookmarks_usecase.dart';
import 'package:quran_app/features/bookmark/domain/usecases/save_bookmark_usecase.dart';

/// Registers bookmark feature dependencies.
void registerBookmarkDependencies(GetIt locator) {
  locator.registerLazySingleton<GetBookmarksUseCase>(
    () => GetBookmarksUseCase(locator()),
  );
  locator.registerLazySingleton<SaveBookmarkUseCase>(
    () => SaveBookmarkUseCase(locator()),
  );
  locator.registerLazySingleton<DeleteBookmarkUseCase>(
    () => DeleteBookmarkUseCase(locator()),
  );

  locator.registerLazySingleton<BookmarkRepository>(
    () => BookmarkRepositoryImpl(databaseHelper: locator()),
  );
}
