import 'dart:convert';

import 'package:quran_app/core/cache/cache_service.dart';
import 'package:quran_app/features/jadwal_sholat/data/datasources/jadwal_sholat_local_datasource.dart';
import 'package:quran_app/features/jadwal_sholat/data/models/jadwal_sholat_model.dart';

/// [JadwalSholatLocalDatasource] implementation using [CacheService].
class JadwalSholatLocalDatasourceImpl implements JadwalSholatLocalDatasource {
  const JadwalSholatLocalDatasourceImpl({required CacheService cacheService})
      : _cacheService = cacheService;

  final CacheService _cacheService;

  static const String _prefix = 'jadwal_sholat_';

  @override
  JadwalSholatModel? getCachedJadwal({required String date}) {
    final String? cached = _cacheService.get('$_prefix$date');
    if (cached == null) return null;

    try {
      final Map<String, dynamic> decoded =
          json.decode(cached) as Map<String, dynamic>;
      return JadwalSholatModel.fromMap(decoded);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheJadwal({
    required String date,
    required JadwalSholatModel jadwal,
  }) async {
    final String encoded = json.encode(jadwal.toMap());
    await _cacheService.put('$_prefix$date', encoded);
  }
}
