import 'package:quran_app/features/surah/data/models/surah_model.dart';

/// Local cache datasource for surah list.
///
/// Stores and retrieves the full surah list JSON from [CacheService].
/// Since Quran content is static, cached data never expires.
abstract class SurahLocalDatasource {
  /// Returns cached surah list, or null if not cached.
  List<SurahModel>? getCachedSurah();

  /// Stores the surah list in cache.
  Future<void> cacheSurah(List<SurahModel> surahList);
}
