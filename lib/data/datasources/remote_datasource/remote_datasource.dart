import 'package:dio/dio.dart';
import 'package:quran_app/data/datasources/crash_reporter.dart';
import 'package:quran_app/data/datasources/http_client.dart';
import 'package:quran_app/data/model/detail_model.dart';
import 'package:quran_app/data/model/jadwal_sholat_model.dart';
import 'package:quran_app/data/model/surah_model.dart';

abstract class RemoteDatasource {
  Future<List<SurahModel>> getSurah();
  Future<DetailModel> getDetailSurah({required final int nomor});
  Future<JadwalSholatModel> getJadwalSholat({
    required final double latitude,
    required final double longitude,
    required final String date,
  });
}

class RemoteDatasourceImpl implements RemoteDatasource {
  final AppHttpClient _httpClient;
  final CrashReporter _crashReporter;
  final String _baseUrlSurah;
  final String _baseUrlJadwalSholat;

  RemoteDatasourceImpl({
    required AppHttpClient httpClient,
    required CrashReporter crashReporter,
    String baseUrlSurah = 'https://equran.id/api/v2/surat',
    String baseUrlJadwalSholat = 'https://api.aladhan.com/v1/timings',
  })  : _httpClient = httpClient,
        _crashReporter = crashReporter,
        _baseUrlSurah = baseUrlSurah,
        _baseUrlJadwalSholat = baseUrlJadwalSholat;

  @override
  Future<List<SurahModel>> getSurah() async {
    try {
      final String response = await _httpClient.get(
        url: _baseUrlSurah,
        requestName: 'getSurah',
      );
      return SurahaDioModel.fromJson(response).data;
    } on DioException catch (e, stackTrace) {
      await _crashReporter.recordError(e, stackTrace);
      throw Exception('Gagal mengambil data dari server.');
    } catch (e, stackTrace) {
      await _crashReporter.recordError(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<DetailModel> getDetailSurah({required final int nomor}) async {
    try {
      final String response = await _httpClient.get(
        url: '$_baseUrlSurah/$nomor',
        requestName: 'getDetailSurah',
      );
      return ResponseDetailModel.fromJson(response).data;
    } on DioException catch (e, stackTrace) {
      await _crashReporter.recordError(e, stackTrace);
      throw Exception('Gagal mengambil data dari server.');
    } catch (e, stackTrace) {
      await _crashReporter.recordError(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<JadwalSholatModel> getJadwalSholat({
    required final double latitude,
    required final double longitude,
    required final String date,
  }) async {
    try {
      final String response = await _httpClient.get(
        url:
            '$_baseUrlJadwalSholat/$date?latitude=$latitude&longitude=$longitude',
        requestName: 'getJadwalSholat',
      );
      return JadwalSholatDioModel.fromJson(response).data.timings;
    } on DioException catch (e, stackTrace) {
      await _crashReporter.recordError(e, stackTrace);
      throw Exception('Gagal mengambil data dari server.');
    } catch (e, stackTrace) {
      await _crashReporter.recordError(e, stackTrace);
      rethrow;
    }
  }
}
