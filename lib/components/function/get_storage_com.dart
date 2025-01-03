part of 'main_function.dart';

mixin GetStorageComponent {
  static GetStorage? _gs;

  GetStorage get gs {
    if (_gs != null) return _gs!;
    _gs = GetStorage();
    return _gs!;
  }

  Future setString({
    required String cKey,
    required String cValue,
  }) async {
    return gs.write(cKey, cValue);
  }

  Future setModel({
    required String cKey,
    required SurahEntity cValue,
  }) async {
    return gs.write(cKey, cValue);
  }

  SurahEntity getModel({
    required String cKey,
  }) {
    C.showLog(log: '--${gs.read(cKey)}');
    return gs.read(cKey);
  }

  String getString({
    required String cKey,
    String cDefaultValue = "",
  }) {
    return gs.read(cKey) ?? cDefaultValue;
  }

  Future setInt({
    required String cKey,
    required int nValue,
  }) async {
    return gs.write(cKey, nValue);
  }

  int getInt({
    required String cKey,
    required int nDefaultValue,
  }) {
    return gs.read(cKey) ?? nDefaultValue;
  }

  Future setBool({
    required String cKey,
    required bool lValue,
  }) async {
    return gs.write(cKey, lValue);
  }

  bool getBool({
    required String cKey,
    required bool lDefaultValue,
  }) {
    return gs.read(cKey) ?? lDefaultValue;
  }

  Future clearCache({
    required String cKey,
  }) {
    return gs.remove(cKey);
  }

  Future clearAllCache() {
    return gs.erase();
  }
}
