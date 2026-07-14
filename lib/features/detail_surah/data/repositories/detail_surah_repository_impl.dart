import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/exceptions.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/detail_surah/data/models/detail_model.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';
import 'package:quran_app/features/detail_surah/domain/repositories/detail_surah_repository.dart';
import 'package:quran_app/features/surah/data/datasources/surah_datasource.dart';

class DetailSurahRepositoryImpl implements DetailSurahRepository {
  const DetailSurahRepositoryImpl({required this.datasource});
  final SurahDatasource datasource;

  @override
  Future<Either<Failure, DetailEntity>> getDetailSurah({
    required final int nomor,
  }) async {
    try {
      final DetailModel result = await datasource.getDetailSurah(nomor: nomor);
      return Right(result.toEntity());
    } on ConnectionException catch (e) {
      return Left(ConnectionFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
