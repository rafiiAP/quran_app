import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/exceptions.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/core/services/connectivity_service.dart';
import 'package:quran_app/features/jadwal_sholat/data/datasources/jadwal_sholat_datasource.dart';
import 'package:quran_app/features/jadwal_sholat/data/datasources/jadwal_sholat_local_datasource.dart';
import 'package:quran_app/features/jadwal_sholat/data/models/jadwal_sholat_model.dart';
import 'package:quran_app/features/jadwal_sholat/domain/entities/jadwal_sholat_entity.dart';
import 'package:quran_app/features/jadwal_sholat/domain/repositories/jadwal_sholat_repository.dart';

/// Repository implementation with offline-first caching strategy.
///
/// 1. Try to return data from local cache for the given date.
/// 2. If cache is empty, check connectivity and fetch from remote.
/// 3. Cache the remote result for next time.
/// 4. If offline and no cache, return a user-friendly connection failure.
class JadwalSholatRepositoryImpl implements JadwalSholatRepository {
  const JadwalSholatRepositoryImpl({
    required JadwalSholatDatasource datasource,
    required JadwalSholatLocalDatasource localDatasource,
    required ConnectivityService connectivityService,
  })  : _datasource = datasource,
        _localDatasource = localDatasource,
        _connectivityService = connectivityService;

  final JadwalSholatDatasource _datasource;
  final JadwalSholatLocalDatasource _localDatasource;
  final ConnectivityService _connectivityService;

  @override
  Future<Either<Failure, JadwalSholatEntity>> getJadwalSholat({
    required final double latitude,
    required final double longitude,
    required final String date,
  }) async {
    // Try cache first
    final JadwalSholatModel? cached =
        _localDatasource.getCachedJadwal(date: date);
    if (cached != null) {
      return Right(cached.toEntity());
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
      final JadwalSholatModel result = await _datasource.getJadwalSholat(
        latitude: latitude,
        longitude: longitude,
        date: date,
      );

      // Cache the result for next time
      await _localDatasource.cacheJadwal(date: date, jadwal: result);

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
