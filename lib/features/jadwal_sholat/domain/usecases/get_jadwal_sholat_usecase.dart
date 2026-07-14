import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/jadwal_sholat/domain/entities/jadwal_sholat_entity.dart';
import 'package:quran_app/features/jadwal_sholat/domain/repositories/jadwal_sholat_repository.dart';

class GetJadwalSholatUseCase {
  const GetJadwalSholatUseCase(this._repository);
  final JadwalSholatRepository _repository;

  Future<Either<Failure, JadwalSholatEntity>> call({
    required double latitude,
    required double longitude,
    required String date,
  }) {
    return _repository.getJadwalSholat(
      latitude: latitude,
      longitude: longitude,
      date: date,
    );
  }
}
