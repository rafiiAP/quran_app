import 'package:quran_app/core/cache/cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [CacheService] implementation backed by [SharedPreferences].
///
/// Stores cached API response JSON strings with a key prefix
/// to avoid collisions with other SharedPreferences usage.
///
/// TTL support uses a companion key (`_ttl_<key>`) to store the
/// expiry timestamp. Expiration is checked lazily on read.
class SharedPreferencesCacheService implements CacheService {
  SharedPreferencesCacheService({required SharedPreferences prefs})
      : _prefs = prefs;

  final SharedPreferences _prefs;

  static const String _prefix = 'cache_';
  static const String _ttlPrefix = 'cache_ttl_';

  @override
  String? get(String key) {
    // Check TTL expiration
    final int? expiresAt = _prefs.getInt('$_ttlPrefix$key');
    if (expiresAt != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now >= expiresAt) {
        // Entry expired — clean up lazily
        _prefs.remove('$_prefix$key');
        _prefs.remove('$_ttlPrefix$key');
        return null;
      }
    }
    return _prefs.getString('$_prefix$key');
  }

  @override
  Future<void> put(String key, String value) async {
    await _prefs.setString('$_prefix$key', value);
    // Remove any existing TTL (permanent cache)
    await _prefs.remove('$_ttlPrefix$key');
  }

  @override
  Future<void> putWithTtl(String key, String value, Duration ttl) async {
    await _prefs.setString('$_prefix$key', value);
    final expiresAt =
        DateTime.now().millisecondsSinceEpoch + ttl.inMilliseconds;
    await _prefs.setInt('$_ttlPrefix$key', expiresAt);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove('$_prefix$key');
    await _prefs.remove('$_ttlPrefix$key');
  }

  @override
  Future<void> clear() async {
    final keys = _prefs
        .getKeys()
        .where((key) => key.startsWith(_prefix) || key.startsWith(_ttlPrefix))
        .toList();
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
}
