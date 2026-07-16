import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/bookmark/domain/entities/bookmark_entity.dart';
import 'package:quran_app/features/bookmark/domain/repositories/bookmark_repository.dart';

/// Use case for retrieving all bookmarks.
class GetBookmarksUseCase {
  const GetBookmarksUseCase(this._repository);
  final BookmarkRepository _repository;

  Future<Either<Failure, List<BookmarkEntity>>> call() {
    return _repository.getAllBookmarks();
  }
}
