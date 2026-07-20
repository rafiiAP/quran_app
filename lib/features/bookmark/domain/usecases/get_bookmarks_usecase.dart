import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/core/usecases/usecase.dart';
import 'package:quran_app/features/bookmark/domain/entities/bookmark_entity.dart';
import 'package:quran_app/features/bookmark/domain/repositories/bookmark_repository.dart';

/// Use case for retrieving all bookmarks.
class GetBookmarksUseCase extends UseCaseNoParams<List<BookmarkEntity>> {
  const GetBookmarksUseCase(this._repository);
  final BookmarkRepository _repository;

  @override
  Future<Either<Failure, List<BookmarkEntity>>> call() {
    return _repository.getAllBookmarks();
  }
}
