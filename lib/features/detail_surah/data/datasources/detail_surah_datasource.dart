import 'package:dio/dio.dart';
import 'package:quran_app/core/error/exceptions.dart';
import 'package:quran_app/core/network/http_client.dart';
import 'package:quran_app/core/services/crash_reporter.dart';
import 'package:quran_app/features/detail_surah/data/models/detail_model.dart';

/// Abstract datasource for Detail Surah API calls.
abstract class DetailSurahDatasource {
  Future<DetailModel> getDetailSurah({required int nomor});
}

/// Concrete implementation calling the equran.id API.
class DetailSurahDatasourceImpl implements DetailSurahDatasource {
  const DetailSurahDatasourceImpl({
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
