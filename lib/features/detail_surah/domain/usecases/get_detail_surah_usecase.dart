import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';
import 'package:quran_app/features/detail_surah/domain/repositories/detail_surah_repository.dart';

class GetDetailSurahUseCase {
  const GetDetailSurahUseCase(this._repository);
  final DetailSurahRepository _repository;

  Future<Either<Failure, DetailEntity>> call({required int nomor}) {
    return _repository.getDetailSurah(nomor: nomor);
  }
}
