import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/surah/domain/entities/surah_entity.dart';

abstract class SurahRepository {
  Future<Either<Failure, List<SurahEntity>>> getSurah();
}
