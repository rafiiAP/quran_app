import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/data/datasources/remote_datasource/remote_datasource.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';
import 'package:quran_app/domain/repositories/quran_repository.dart';

class RemoteRepositoryImpl implements RemoteRepository {
  final RemoteDatasource quranDatasource;

  RemoteRepositoryImpl({required this.quranDatasource});

  @override
  Future<Either<Failure, List<SurahEntity>>> getSurah() async {
    try {
      var result = await quranDatasource.getSurah();
      return right(result.map((model) => model.toEntity()).toList());
    } on DioException catch (e, stackTrace) {
      C.showLog(
          log:
              "❌ DioException terjadi: ${e.toString()} \nStackTrace: $stackTrace");
      return left(const ConnectionFailure("Gagal mengambil data dari server."));
    } catch (e, stackTrace) {
      C.showLog(
          log: "❌ Unexpected error: ${e.toString()} \nStackTrace: $stackTrace");
      return left(const ResponseFailure(
          "Terjadi kesalahan internal, coba lagi nanti."));
    }
  }

  @override
  Future<Either<Failure, DetailEntity>> getDetailSurah(
      {required int nomor}) async {
    try {
      var result = await quranDatasource.getDetailSurah(nomor: nomor);
      return right(result.toEntity());
    } on DioException catch (e, stackTrace) {
      C.showLog(
          log:
              "❌ DioException terjadi: ${e.toString()} \nStackTrace: $stackTrace");
      return left(const ConnectionFailure("Gagal mengambil data dari server."));
    } catch (e, stackTrace) {
      C.showLog(
          log: "❌ Unexpected error: ${e.toString()} \nStackTrace: $stackTrace");
      return left(const ResponseFailure(
          "Terjadi kesalahan internal, coba lagi nanti."));
    }
  }

  @override
  Future<Either<Failure, JadwalSholatEntity>> getJadwalSholat({
    required double latitude,
    required double longitude,
    required String date,
  }) async {
    {
      try {
        var result = await quranDatasource.getJadwalSholat(
            latitude: latitude, longitude: longitude, date: date);
        return right(result.toEntity());
      } on DioException catch (e, stackTrace) {
        C.showLog(
            log:
                "❌ DioException terjadi: ${e.toString()} \nStackTrace: $stackTrace");
        return left(
            const ConnectionFailure("Gagal mengambil data dari server."));
      } catch (e, stackTrace) {
        C.showLog(
            log:
                "❌ Unexpected error: ${e.toString()} \nStackTrace: $stackTrace");
        return left(const ResponseFailure(
            "Terjadi kesalahan internal, coba lagi nanti."));
      }
    }
  }
}
