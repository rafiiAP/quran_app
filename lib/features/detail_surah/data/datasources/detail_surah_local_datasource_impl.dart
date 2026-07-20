import 'package:quran_app/core/cache/cache_service.dart';
import 'package:quran_app/features/detail_surah/data/datasources/detail_surah_local_datasource.dart';
import 'package:quran_app/features/detail_surah/data/models/detail_model.dart';

/// [DetailSurahLocalDatasource] implementation using [CacheService].
class DetailSurahLocalDatasourceImpl implements DetailSurahLocalDatasource {
  const DetailSurahLocalDatasourceImpl({required CacheService cacheService})
      : _cacheService = cacheService;

  final CacheService _cacheService;

  String _cacheKey(int nomor) => 'detail_surah_$nomor';

  @override
  DetailModel? getCachedDetail({required int nomor}) {
    final String? cached = _cacheService.get(_cacheKey(nomor));
    if (cached == null) return null;

    try {
      return DetailModel.fromJson(cached);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheDetail({
    required int nomor,
    required DetailModel detail,
  }) async {
    await _cacheService.put(_cacheKey(nomor), detail.toJson());
  }
}
