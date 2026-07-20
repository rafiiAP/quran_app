import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/core/models/bookmark_input.dart';

/// Core-level contract for saving bookmarks.
///
/// Lives in `core/` to allow any feature to depend on it without
/// importing from the `bookmark` feature directly. This preserves
/// feature isolation — `detail_surah` can save bookmarks without
/// a direct dependency on `bookmark/domain/usecases/`.
///
/// The concrete implementation still lives in the bookmark feature.
abstract class SaveBookmarkAction {
  /// Returns `Right(true)` if newly inserted, `Right(false)` if already existed.
  Future<Either<Failure, bool>> call({required BookmarkInput input});
}
