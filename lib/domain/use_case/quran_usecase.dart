import 'package:dartz/dartz.dart';
import 'package:quran_app/data/model/detail_model.dart';
import 'package:quran_app/data/model/surah_model.dart';
import 'package:quran_app/domain/repositories/quran_repository.dart';

class QuranUsecase {
  final QuranRepository repositoryAPI;
  QuranUsecase(this.repositoryAPI);

  Future<Either<Failure, HTTPModel>> getSurah() {
    return repositoryAPI.getSurah();
  }

  Future<Either<Failure, HttpDetailModel>> getDetailSurah({required int nomor}) {
    return repositoryAPI.getDetailSurah(nomor: nomor);
  }
}
