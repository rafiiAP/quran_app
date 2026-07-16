import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';

/// Use case for saving a bookmark.
///
/// Returns `Right(true)` if newly inserted, `Right(false)` if already existed.
class SaveBookmarkUseCase {
  const SaveBookmarkUseCase(this._repository);
  final BookmarkRepository _repository;

  Future<Either<Failure, bool>> call({
    required AyatDetailEntity ayat,
    required DetailEntity detail,
  }) {
    return _repository.insertOrUpdateBookmark(ayat, detail);
  }
}
