import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quran_app/data/datasources/quran/quran_datasource.dart';
import 'package:quran_app/data/model/detail_model.dart';
import 'package:quran_app/data/model/surah_model.dart';
import 'package:quran_app/domain/repositories/quran_repository.dart';

class QuranRepositoryImpl extends QuranRepository {
  QuranDatasource quranDatasource = QuranDatasource();

  @override
  Future<Either<Failure, HTTPModel>> getSurah() async {
    try {
      var result = await quranDatasource.getSurah();
      return right(result);
    } on DioException catch (e) {
      return left(ConnectionFailure(e.toString()));
    } catch (e) {
      return left(ResponseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HttpDetailModel>> getDetailSurah({required int nomor}) async {
    try {
      var result = await quranDatasource.getDetailSurah(nomor: nomor);
      return right(result);
    } on DioException catch (e) {
      return left(ConnectionFailure(e.toString()));
    } catch (e) {
      return left(ResponseFailure(e.toString()));
    }
  }
}
