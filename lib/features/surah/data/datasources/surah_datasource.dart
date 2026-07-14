import 'package:dio/dio.dart';
import 'package:quran_app/core/error/exceptions.dart';
import 'package:quran_app/core/network/http_client.dart';
import 'package:quran_app/core/services/crash_reporter.dart';
import 'package:quran_app/features/detail_surah/data/models/detail_model.dart';
import 'package:quran_app/features/surah/data/models/surah_model.dart';

/// Abstract datasource for Surah-related API calls.
abstract class SurahDatasource {
  Future<List<SurahModel>> getSurah();
  Future<DetailModel> getDetailSurah({required int nomor});
}

/// Concrete implementation calling the equran.id API.
class SurahDatasourceImpl implements SurahDatasource {
  const SurahDatasourceImpl({
    required AppHttpClient httpClient,
    required CrashReporter crashReporter,
    required String baseUrl,
  })  : _httpClient = httpClient,
        _crashReporter = crashReporter,
        _baseUrl = baseUrl;

  final AppHttpClient _httpClient;
  final CrashReporter _crashReporter;
  final String _baseUrl;

  @override
  Future<List<SurahModel>> getSurah() async {
    try {
      final String response = await _httpClient.get(
        url: _baseUrl,
        requestName: 'getSurah',
      );
      return SurahaDioModel.fromJson(response).data;
    } on DioException catch (e, stackTrace) {
      await _crashReporter.recordError(e, stackTrace);
      throw ConnectionException(
        e.message ?? 'Gagal terhubung ke server.',
      );
    } catch (e, stackTrace) {
      await _crashReporter.recordError(e, stackTrace);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<DetailModel> getDetailSurah({required final int nomor}) async {
    try {
      final String response = await _httpClient.get(
        url: '$_baseUrl/$nomor',
        requestName: 'getDetailSurah',
      );
      return ResponseDetailModel.fromJson(response).data;
    } on DioException catch (e, stackTrace) {
      await _crashReporter.recordError(e, stackTrace);
      throw ConnectionException(
        e.message ?? 'Gagal terhubung ke server.',
      );
    } catch (e, stackTrace) {
      await _crashReporter.recordError(e, stackTrace);
      throw ServerException(e.toString());
    }
  }
}
