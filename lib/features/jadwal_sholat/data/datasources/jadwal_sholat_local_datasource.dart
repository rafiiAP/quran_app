import 'dart:convert';

import 'package:quran_app/core/cache/cache_service.dart';
import 'package:quran_app/features/jadwal_sholat/data/models/jadwal_sholat_model.dart';

/// Local cache datasource for prayer schedule.
///
/// Stores and retrieves prayer times JSON keyed by date.
/// Prayer times are date-specific, so cached data is keyed by the
/// request date string (e.g. "15-07-2026").
abstract class JadwalSholatLocalDatasource {
  /// Returns cached prayer times for [date], or null if not cached.
  JadwalSholatModel? getCachedJadwal({required String date});

  /// Stores prayer times in cache, keyed by [date].
  Future<void> cacheJadwal({
    required String date,
    required JadwalSholatModel jadwal,
  });
}

/// Implementation using [CacheService].
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
