import 'dart:convert';

import 'package:quran_app/core/cache/cache_service.dart';
import 'package:quran_app/features/surah/data/datasources/surah_local_datasource.dart';
import 'package:quran_app/features/surah/data/models/surah_model.dart';

/// [SurahLocalDatasource] implementation using [CacheService].
class SurahLocalDatasourceImpl implements SurahLocalDatasource {
  const SurahLocalDatasourceImpl({required CacheService cacheService})
      : _cacheService = cacheService;

  final CacheService _cacheService;

  static const String _cacheKey = 'surah_list';

  @override
  List<SurahModel>? getCachedSurah() {
    final String? cached = _cacheService.get(_cacheKey);
    if (cached == null) return null;

    try {
      final List<dynamic> decoded = json.decode(cached) as List<dynamic>;
      return decoded
          .map(
            (final dynamic item) =>
                SurahModel.fromMap(item as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheSurah(List<SurahModel> surahList) async {
    final String encoded = json.encode(
      surahList.map((final SurahModel model) => model.toMap()).toList(),
    );
    await _cacheService.put(_cacheKey, encoded);
  }
}
