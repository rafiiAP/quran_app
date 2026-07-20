import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/exceptions.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/core/services/connectivity_service.dart';
import 'package:quran_app/features/jadwal_sholat/data/datasources/jadwal_sholat_datasource.dart';
import 'package:quran_app/features/jadwal_sholat/data/models/jadwal_sholat_model.dart';
import 'package:quran_app/features/jadwal_sholat/domain/entities/jadwal_sholat_entity.dart';
import 'package:quran_app/features/jadwal_sholat/domain/repositories/jadwal_sholat_repository.dart';

class JadwalSholatRepositoryImpl implements JadwalSholatRepository {
  const JadwalSholatRepositoryImpl({
    required this.datasource,
    required this.connectivityService,
  });

  final JadwalSholatDatasource datasource;
  final ConnectivityService connectivityService;

  @override
  Future<Either<Failure, JadwalSholatEntity>> getJadwalSholat({
    required final double latitude,
    required final double longitude,
    required final String date,
  }) async {
    // Check connectivity before attempting network call
    final bool isConnected = await connectivityService.hasConnection();
    if (!isConnected) {
      return const Left(
        ConnectionFailure('Tidak ada koneksi internet. Periksa jaringan Anda.'),
      );
    }

    try {
      final JadwalSholatModel result = await datasource.getJadwalSholat(
        latitude: latitude,
        longitude: longitude,
        date: date,
      );
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
