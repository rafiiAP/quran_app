import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quran_app/data/datasources/local_storage_service.dart';

/// [LocalStorageService] implementation backed by [FlutterSecureStorage].
///
/// Suitable for storing sensitive data. Note that the synchronous read
/// methods ([getString], [getInt], [getBool]) return [defaultValue]
/// immediately — secure storage is async by nature and sensitive values
/// should be read via the underlying [FlutterSecureStorage] API when
/// async access is required.
class SecureStorageService implements LocalStorageService {
  final FlutterSecureStorage _secureStorage;

  SecureStorageService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  @override
  Future<void> setString({required String key, required String value}) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  String getString({required String key, String defaultValue = ''}) {
    // Sync getter — returns defaultValue; use FlutterSecureStorage.read()
    // directly when async access to sensitive data is needed.
    return defaultValue;
  }

  @override
  Future<void> setInt({required String key, required int value}) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  @override
  int getInt({required String key, int defaultValue = 0}) {
    return defaultValue;
  }

  @override
  Future<void> setBool({required String key, required bool value}) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  @override
  bool getBool({required String key, bool defaultValue = false}) {
    return defaultValue;
  }

  @override
  Future<void> remove({required String key}) async {
    await _secureStorage.delete(key: key);
  }

  @override
  Future<void> clear() async {
    await _secureStorage.deleteAll();
  }
}
