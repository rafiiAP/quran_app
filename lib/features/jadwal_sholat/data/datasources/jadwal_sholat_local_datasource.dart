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
