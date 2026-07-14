import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/jadwal_sholat/domain/entities/jadwal_sholat_entity.dart';

abstract class JadwalSholatRepository {
  Future<Either<Failure, JadwalSholatEntity>> getJadwalSholat({
    required double latitude,
    required double longitude,
    required String date,
  });
}
