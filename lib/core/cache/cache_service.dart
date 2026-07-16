/// Abstract cache service for storing and retrieving JSON string data.
///
/// Implementations handle storage mechanics. Cache entries are keyed by
/// string identifiers and stored as raw JSON strings.
/// This keeps the cache layer agnostic to data models.
abstract class CacheService {
  /// Retrieves cached JSON string for [key], or null if not cached.
  String? get(String key);

  /// Stores a JSON string [value] under [key].
  Future<void> put(String key, String value);

  /// Removes the cached entry for [key].
  Future<void> remove(String key);

  /// Clears all cached entries.
  Future<void> clear();
}
