import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/core/usecases/usecase.dart';
import 'package:quran_app/features/jadwal_sholat/domain/entities/jadwal_sholat_entity.dart';
import 'package:quran_app/features/jadwal_sholat/domain/repositories/jadwal_sholat_repository.dart';

/// Parameters for [GetJadwalSholatUseCase].
class JadwalSholatParams extends Equatable {
  const JadwalSholatParams({
    required this.latitude,
    required this.longitude,
    required this.date,
  });

  final double latitude;
  final double longitude;
  final String date;

  @override
  List<Object?> get props => [latitude, longitude, date];
}

/// Use case for retrieving prayer schedule.
class GetJadwalSholatUseCase
    extends UseCase<JadwalSholatEntity, JadwalSholatParams> {
  const GetJadwalSholatUseCase(this._repository);
  final JadwalSholatRepository _repository;

  @override
  Future<Either<Failure, JadwalSholatEntity>> call(
    JadwalSholatParams params,
  ) {
    return _repository.getJadwalSholat(
      latitude: params.latitude,
      longitude: params.longitude,
      date: params.date,
    );
  }
}
