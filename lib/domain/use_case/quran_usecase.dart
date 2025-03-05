import 'package:dartz/dartz.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';

import 'package:quran_app/domain/entity/surah_entity.dart';
import 'package:quran_app/domain/repositories/quran_repository.dart';

class RemoteUsecase {
  final RemoteRepository repositoryAPI;
  RemoteUsecase(this.repositoryAPI);

  Future<Either<Failure, List<SurahEntity>>> execute() {
    return repositoryAPI.getSurah();
  }

  Future<Either<Failure, DetailEntity>> getDetailSurah({required int nomor}) {
    return repositoryAPI.getDetailSurah(nomor: nomor);
  }

  Future<Either<Failure, JadwalSholatEntity>> getJadwalSholat(
      {required double latitude, required double longitude, required String date}) {
    return repositoryAPI.getJadwalSholat(latitude: latitude, longitude: longitude, date: date);
  }
}
