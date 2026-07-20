import 'package:quran_app/core/models/bookmark_input.dart';

/// Abstract local datasource for bookmark persistence.
///
/// Isolates the repository from direct database access,
/// following the same datasource pattern used by other features.
abstract class BookmarkLocalDatasource {
  /// Inserts the bookmark if it doesn't already exist.
  /// Returns `true` if newly inserted, `false` if already existed.
  Future<bool> insertBookmark(BookmarkInput input);

  /// Returns all saved bookmarks as raw maps.
  Future<List<Map<String, dynamic>>> getAllBookmarks();

  /// Deletes the bookmark identified by its database [id].
  Future<void> deleteBookmark(int id);
}
