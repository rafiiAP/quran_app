import 'package:dartz/dartz.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';

import 'package:quran_app/domain/entity/surah_entity.dart';
import 'package:quran_app/domain/repositories/remote_repository.dart';

class RemoteUsecase {
  RemoteUsecase(this.repositoryAPI);
  final RemoteRepository repositoryAPI;

  Future<Either<Failure, List<SurahEntity>>> execute() {
    return repositoryAPI.getSurah();
  }

  Future<Either<Failure, DetailEntity>> getDetailSurah(
      {required final int nomor}) {
    return repositoryAPI.getDetailSurah(nomor: nomor);
  }

  Future<Either<Failure, JadwalSholatEntity>> getJadwalSholat({
    required final double latitude,
    required final double longitude,
    required final String date,
  }) {
    return repositoryAPI.getJadwalSholat(
        latitude: latitude, longitude: longitude, date: date);
  }
}
