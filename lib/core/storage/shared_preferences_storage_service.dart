import 'package:quran_app/core/storage/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [LocalStorageService] implementation backed by [SharedPreferences].
///
/// Suitable for storing non-sensitive data such as onboarding flags,
/// last-read surah/ayat, and showcase state.
class SharedPreferencesStorageService implements LocalStorageService {
  final SharedPreferences _prefs;

  SharedPreferencesStorageService({required SharedPreferences prefs})
      : _prefs = prefs;

  @override
  Future<void> setString({required String key, required String value}) async {
    await _prefs.setString(key, value);
  }

  @override
  String getString({required String key, String defaultValue = ''}) {
    return _prefs.getString(key) ?? defaultValue;
  }

  @override
  Future<void> setInt({required String key, required int value}) async {
    await _prefs.setInt(key, value);
  }

  @override
  int getInt({required String key, int defaultValue = 0}) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  @override
  Future<void> setBool({required String key, required bool value}) async {
    await _prefs.setBool(key, value);
  }

  @override
  bool getBool({required String key, bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  @override
  Future<void> remove({required String key}) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }
}
