import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/exceptions.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/core/services/connectivity_service.dart';
import 'package:quran_app/features/detail_surah/data/datasources/detail_surah_datasource.dart';
import 'package:quran_app/features/detail_surah/data/datasources/detail_surah_local_datasource.dart';
import 'package:quran_app/features/detail_surah/data/models/detail_model.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';
import 'package:quran_app/features/detail_surah/domain/repositories/detail_surah_repository.dart';

/// Repository implementation with offline-first caching strategy.
///
/// 1. Try to return data from local cache immediately.
/// 2. If cache is empty, check connectivity and fetch from remote.
/// 3. Cache the remote result for next time.
/// 4. If offline and no cache, return a user-friendly connection failure.
class DetailSurahRepositoryImpl implements DetailSurahRepository {
  const DetailSurahRepositoryImpl({
    required this.datasource,
    required this.localDatasource,
    required this.connectivityService,
  });

  final DetailSurahDatasource datasource;
  final DetailSurahLocalDatasource localDatasource;
  final ConnectivityService connectivityService;

  @override
  Future<Either<Failure, DetailEntity>> getDetailSurah({
    required final int nomor,
  }) async {
    // Try cache first
    final DetailModel? cached = localDatasource.getCachedDetail(nomor: nomor);
    if (cached != null) {
      return Right(cached.toEntity());
    }

    // Cache miss — check connectivity before attempting network call
    final bool isConnected = await connectivityService.hasConnection();
    if (!isConnected) {
      return const Left(
        ConnectionFailure('Tidak ada koneksi internet. Periksa jaringan Anda.'),
      );
    }

    // Fetch from remote
    try {
      final DetailModel result = await datasource.getDetailSurah(nomor: nomor);

      // Cache the result for next time
      await localDatasource.cacheDetail(nomor: nomor, detail: result);

      return Right(result.toEntity());
    } on ConnectionException catch (e) {
      return Left(ConnectionFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
