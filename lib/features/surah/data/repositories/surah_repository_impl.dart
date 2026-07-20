import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/exceptions.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/core/services/connectivity_service.dart';
import 'package:quran_app/features/surah/data/datasources/surah_datasource.dart';
import 'package:quran_app/features/surah/data/datasources/surah_local_datasource.dart';
import 'package:quran_app/features/surah/data/models/surah_model.dart';
import 'package:quran_app/features/surah/domain/entities/surah_entity.dart';
import 'package:quran_app/features/surah/domain/repositories/surah_repository.dart';

/// Repository implementation with offline-first caching strategy.
///
/// 1. Try to return data from local cache immediately.
/// 2. If cache is empty, check connectivity and fetch from remote.
/// 3. Cache the remote result for next time.
/// 4. If offline and no cache, return a user-friendly connection failure.
class SurahRepositoryImpl implements SurahRepository {
  const SurahRepositoryImpl({
    required SurahDatasource datasource,
    required SurahLocalDatasource localDatasource,
    required ConnectivityService connectivityService,
  })  : _datasource = datasource,
        _localDatasource = localDatasource,
        _connectivityService = connectivityService;

  final SurahDatasource _datasource;
  final SurahLocalDatasource _localDatasource;
  final ConnectivityService _connectivityService;

  @override
  Future<Either<Failure, List<SurahEntity>>> getSurah() async {
    // Try cache first
    final List<SurahModel>? cached = _localDatasource.getCachedSurah();
    if (cached != null && cached.isNotEmpty) {
      return Right(
        cached.map((final SurahModel model) => model.toEntity()).toList(),
      );
    }

    // Cache miss — check connectivity before attempting network call
    final bool isConnected = await _connectivityService.hasConnection();
    if (!isConnected) {
      return const Left(
        ConnectionFailure('Tidak ada koneksi internet. Periksa jaringan Anda.'),
      );
    }

    // Fetch from remote
    try {
      final List<SurahModel> result = await _datasource.getSurah();

      // Cache the result for next time
      await _localDatasource.cacheSurah(result);

      return Right(
        result.map((final SurahModel model) => model.toEntity()).toList(),
      );
    } on ConnectionException catch (e) {
      return Left(ConnectionFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
