import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/exceptions.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/surah/data/datasources/surah_datasource.dart';
import 'package:quran_app/features/surah/data/models/surah_model.dart';
import 'package:quran_app/features/surah/domain/entities/surah_entity.dart';
import 'package:quran_app/features/surah/domain/repositories/surah_repository.dart';

class SurahRepositoryImpl implements SurahRepository {
  const SurahRepositoryImpl({required this.datasource});
  final SurahDatasource datasource;

  @override
  Future<Either<Failure, List<SurahEntity>>> getSurah() async {
    try {
      final List<SurahModel> result = await datasource.getSurah();
      return Right(
        result.map((final SurahModel model) => model.toEntity()).toList(),
      );
    } on ConnectionException catch (e) {
      return Left(ConnectionFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
