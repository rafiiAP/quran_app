import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quran_app/data/datasources/quran/quran_datasource.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';
import 'package:quran_app/domain/repositories/quran_repository.dart';

class QuranRepositoryImpl implements QuranRepository {
  final QuranDatasource quranDatasource;

  QuranRepositoryImpl({required this.quranDatasource});

  @override
  Future<Either<Failure, List<SurahEntity>>> getSurah() async {
    try {
      var result = await quranDatasource.getSurah();
      return right(result.map((model) => model.toEntity()).toList());
    } on DioException catch (e) {
      return left(ConnectionFailure(e.toString()));
    } catch (e) {
      return left(ResponseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DetailEntity>> getDetailSurah({required int nomor}) async {
    try {
      var result = await quranDatasource.getDetailSurah(nomor: nomor);
      return right(result.toEntity());
    } on DioException catch (e) {
      return left(ConnectionFailure(e.toString()));
    } catch (e) {
      return left(ResponseFailure(e.toString()));
    }
  }
}
