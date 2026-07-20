import 'package:quran_app/core/network/api_call_handler.dart';
import 'package:quran_app/core/network/http_client.dart';
import 'package:quran_app/core/services/crash_reporter.dart';
import 'package:quran_app/features/surah/data/models/surah_model.dart';

/// Abstract datasource for Surah list API calls.
abstract class SurahDatasource {
  Future<List<SurahModel>> getSurah();
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
    return apiCall(
      crashReporter: _crashReporter,
      call: () async {
        final dynamic response = await _httpClient.get(
          url: _baseUrl,
          requestName: 'getSurah',
        );
        return SurahResponse.fromMap(response as Map<String, dynamic>).data;
      },
    );
  }
}
