import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/core/models/bookmark_input.dart';
import 'package:quran_app/features/bookmark/domain/repositories/bookmark_repository.dart';

/// Use case for saving a bookmark.
///
/// Returns `Right(true)` if newly inserted, `Right(false)` if already existed.
class SaveBookmarkUseCase {
  const SaveBookmarkUseCase(this._repository);
  final BookmarkRepository _repository;

  Future<Either<Failure, bool>> call({required BookmarkInput input}) {
    return _repository.insertOrUpdateBookmark(input);
  }
}
