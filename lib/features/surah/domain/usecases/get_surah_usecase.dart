import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/core/usecases/usecase.dart';
import 'package:quran_app/features/surah/domain/entities/surah_entity.dart';
import 'package:quran_app/features/surah/domain/repositories/surah_repository.dart';

/// Use case for retrieving all surahs.
class GetSurahUseCase extends UseCaseNoParams<List<SurahEntity>> {
  const GetSurahUseCase(this._repository);
  final SurahRepository _repository;

  @override
  Future<Either<Failure, List<SurahEntity>>> call() {
    return _repository.getSurah();
  }
}
