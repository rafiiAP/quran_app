import 'package:quran_app/core/cache/cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [CacheService] implementation backed by [SharedPreferences].
///
/// Stores cached API response JSON strings with a key prefix
/// to avoid collisions with other SharedPreferences usage.
class SharedPreferencesCacheService implements CacheService {
  SharedPreferencesCacheService({required SharedPreferences prefs})
      : _prefs = prefs;

  final SharedPreferences _prefs;

  static const String _prefix = 'cache_';

  @override
  String? get(String key) {
    return _prefs.getString('$_prefix$key');
  }

  @override
  Future<void> put(String key, String value) async {
    await _prefs.setString('$_prefix$key', value);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove('$_prefix$key');
  }

  @override
  Future<void> clear() async {
    final keys =
        _prefs.getKeys().where((key) => key.startsWith(_prefix)).toList();
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
}
