import 'package:dartz/dartz.dart';
import 'package:quran_app/data/model/detail_model.dart';
import 'package:quran_app/data/model/surah_model.dart';
import 'package:quran_app/domain/repositories/quran_repository.dart';
import 'package:quran_app/injection.dart' as di;

class QuranUsecase extends QuranRepository {
  final QuranRepository repositoryAPI = di.locator<QuranRepository>();

  @override
  Future<Either<Failure, HTTPModel>> getSurah() {
    return repositoryAPI.getSurah();
  }

  @override
  Future<Either<Failure, HttpDetailModel>> getDetailSurah({required int nomor}) {
    return repositoryAPI.getDetailSurah(nomor: nomor);
  }
}
