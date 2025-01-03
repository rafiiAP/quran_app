import 'package:dartz/dartz.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';

import 'package:quran_app/domain/entity/surah_entity.dart';
import 'package:quran_app/domain/repositories/quran_repository.dart';

class QuranUsecase {
  final QuranRepository repositoryAPI;
  QuranUsecase(this.repositoryAPI);

  Future<Either<Failure, List<SurahEntity>>> execute() {
    return repositoryAPI.getSurah();
  }

  Future<Either<Failure, DetailEntity>> getDetailSurah({required int nomor}) {
    return repositoryAPI.getDetailSurah(nomor: nomor);
  }
}
