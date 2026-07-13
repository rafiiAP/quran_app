/// Abstract interface for key-value local storage operations.
///
/// Implementations: [SharedPreferencesStorageService] (non-sensitive data),
/// [SecureStorageService] (sensitive data).
abstract class LocalStorageService {
  Future<void> setString({required String key, required String value});
  String getString({required String key, String defaultValue = ''});

  Future<void> setInt({required String key, required int value});
  int getInt({required String key, int defaultValue = 0});

  Future<void> setBool({required String key, required bool value});
  bool getBool({required String key, bool defaultValue = false});

  Future<void> remove({required String key});
  Future<void> clear();
}
