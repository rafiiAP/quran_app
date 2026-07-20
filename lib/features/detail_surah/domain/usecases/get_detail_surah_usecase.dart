import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/core/usecases/usecase.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';
import 'package:quran_app/features/detail_surah/domain/repositories/detail_surah_repository.dart';

/// Use case for retrieving detail of a specific surah.
class GetDetailSurahUseCase extends UseCase<DetailEntity, int> {
  const GetDetailSurahUseCase(this._repository);
  final DetailSurahRepository _repository;

  @override
  Future<Either<Failure, DetailEntity>> call(int nomor) {
    return _repository.getDetailSurah(nomor: nomor);
  }
}
