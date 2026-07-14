import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';

/// Repository contract for fetching detail surah data.
abstract class DetailSurahRepository {
  Future<Either<Failure, DetailEntity>> getDetailSurah({required int nomor});
}
