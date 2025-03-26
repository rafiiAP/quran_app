part of 'main_function.dart';

mixin GetStorageComponent {
  static GetStorage? _gs;

  GetStorage get gs {
    if (_gs != null) return _gs!;
    _gs = GetStorage();
    return _gs!;
  }

  Future<void> setString({
    required final String cKey,
    required final String cValue,
  }) async {
    await gs.write(cKey, cValue);
  }

  String getString({
    required final String cKey,
    final String cDefaultValue = '',
  }) {
    return gs.read(cKey) as String? ?? cDefaultValue;
  }

  Future<void> setModel({
    required final String cKey,
    required final SurahEntity cValue,
  }) async {
    await gs.write(cKey, cValue);
  }

  SurahEntity? getModel({required final String cKey}) {
    final dynamic data = gs.read(cKey);
    return (data is SurahEntity) ? data : null; // ✅ Cek tipe sebelum casting
  }

  Future<void> setInt({
    required final String cKey,
    required final int nValue,
  }) async {
    return gs.write(cKey, nValue);
  }

  int getInt({
    required final String cKey,
    required final int nDefaultValue,
  }) {
    return gs.read(cKey) as int? ?? nDefaultValue;
  }

  Future<void> setBool({
    required final String cKey,
    required final bool lValue,
  }) async {
    await gs.write(cKey, lValue);
  }

  bool getBool({
    required final String cKey,
    required final bool lDefaultValue,
  }) {
    return gs.read(cKey) as bool? ?? lDefaultValue;
  }

  Future<void> clearCache({
    required final String cKey,
  }) async {
    await gs.remove(cKey);
  }

  Future<void> clearAllCache() async {
    await gs.erase();
  }
}
