import 'package:dio/dio.dart';
import 'package:quran_app/core/error/exceptions.dart';
import 'package:quran_app/core/network/http_client.dart';
import 'package:quran_app/core/services/crash_reporter.dart';
import 'package:quran_app/features/jadwal_sholat/data/models/jadwal_sholat_model.dart';

/// Abstract datasource for Jadwal Sholat API calls.
abstract class JadwalSholatDatasource {
  Future<JadwalSholatModel> getJadwalSholat({
    required double latitude,
    required double longitude,
    required String date,
  });
}

/// Concrete implementation calling the aladhan.com API.
class JadwalSholatDatasourceImpl implements JadwalSholatDatasource {
  const JadwalSholatDatasourceImpl({
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
  Future<JadwalSholatModel> getJadwalSholat({
    required final double latitude,
    required final double longitude,
    required final String date,
  }) async {
    try {
      final String response = await _httpClient.get(
        url: '$_baseUrl/$date?latitude=$latitude&longitude=$longitude',
        requestName: 'getJadwalSholat',
      );
      return JadwalSholatDioModel.fromJson(response).data.timings;
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
