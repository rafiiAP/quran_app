import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/core/models/bookmark_input.dart';
import 'package:quran_app/features/bookmark/domain/entities/bookmark_entity.dart';

/// Abstract repository contract for bookmark persistence.
///
/// Returns [Either<Failure, T>] to follow the same error-handling
/// pattern used by all other repositories in this project.
abstract class BookmarkRepository {
  /// Inserts the bookmark if it doesn't already exist.
  /// Returns `Right(true)` if newly inserted, `Right(false)` if already existed.
  Future<Either<Failure, bool>> insertOrUpdateBookmark(BookmarkInput input);

  /// Returns all saved bookmarks as domain entities.
  Future<Either<Failure, List<BookmarkEntity>>> getAllBookmarks();

  /// Deletes the bookmark identified by [teksIndonesia].
  Future<Either<Failure, void>> deleteBookmark(String teksIndonesia);
}
