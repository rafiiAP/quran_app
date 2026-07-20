import 'package:quran_app/features/detail_surah/data/models/detail_model.dart';

/// Local cache datasource for detail surah data.
///
/// Caches individual surah detail JSON keyed by surah number.
/// Since Quran content is static, cached data never expires.
abstract class DetailSurahLocalDatasource {
  /// Returns cached detail for [nomor], or null if not cached.
  DetailModel? getCachedDetail({required int nomor});

  /// Stores the detail for a specific surah in cache.
  Future<void> cacheDetail({required int nomor, required DetailModel detail});
}
