import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quran_app/data/datasources/remote_datasource/remote_datasource.dart';
import 'package:quran_app/data/model/detail_model.dart';
import 'package:quran_app/data/model/jadwal_sholat_model.dart';
import 'package:quran_app/data/model/surah_model.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';
import 'package:quran_app/domain/repositories/remote_repository.dart';

class RemoteRepositoryImpl implements RemoteRepository {
  RemoteRepositoryImpl({required this.quranDatasource});
  final RemoteDatasource quranDatasource;

  @override
  Future<Either<Failure, List<SurahEntity>>> getSurah() async {
    try {
      final List<SurahModel> result = await quranDatasource.getSurah();
      return right(
          result.map((final SurahModel model) => model.toEntity()).toList());
    } on DioException catch (e, stackTrace) {
      throw Exception(<dynamic>[e, stackTrace]);
    } catch (e, stackTrace) {
      throw Exception(<dynamic>[e, stackTrace]);
    }
  }

  @override
  Future<Either<Failure, DetailEntity>> getDetailSurah(
      {required final int nomor}) async {
    try {
      final DetailModel result =
          await quranDatasource.getDetailSurah(nomor: nomor);
      return right(result.toEntity());
    } on DioException catch (e, stackTrace) {
      throw Exception(<dynamic>[e, stackTrace]);
    } catch (e, stackTrace) {
      throw Exception(<dynamic>[e, stackTrace]);
    }
  }

  @override
  Future<Either<Failure, JadwalSholatEntity>> getJadwalSholat({
    required final double latitude,
    required final double longitude,
    required final String date,
  }) async {
    {
      try {
        final JadwalSholatModel result = await quranDatasource.getJadwalSholat(
            latitude: latitude, longitude: longitude, date: date);
        return right(result.toEntity());
      } on DioException catch (e, stackTrace) {
        throw Exception(<dynamic>[e, stackTrace]);
      } catch (e, stackTrace) {
        throw Exception(<dynamic>[e, stackTrace]);
      }
    }
  }
}
