import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/error/exceptions.dart';
import 'package:quran_app/features/surah/data/datasources/surah_datasource.dart';
import 'package:quran_app/features/surah/data/models/surah_model.dart';

import '../../../../mocks.dart';

// ---------------------------------------------------------------------------
// JSON fixtures (decoded to Map for new AppHttpClient contract)
// ---------------------------------------------------------------------------

final Map<String, dynamic> _kSurahMap = json.decode('''
{
  "code": 200,
  "message": "OK",
  "data": [
    {
      "nomor": 1,
      "nama": "الفاتحة",
      "namaLatin": "Al-Fatihah",
      "jumlahAyat": 7,
      "tempatTurun": "Mekah",
      "arti": "Pembuka",
      "deskripsi": "Surah pertama",
      "audioFull": {"01": "https://cdn.example.com/1.mp3"}
    },
    {
      "nomor": 2,
      "nama": "البقرة",
      "namaLatin": "Al-Baqarah",
      "jumlahAyat": 286,
      "tempatTurun": "Madinah",
      "arti": "Sapi",
      "deskripsi": "Surah terpanjang",
      "audioFull": {"01": "https://cdn.example.com/2.mp3"}
    }
  ]
}
''') as Map<String, dynamic>;

void main() {
  late MockAppHttpClient mockHttpClient;
  late MockCrashReporter mockCrashReporter;
  late SurahDatasourceImpl datasource;

  setUp(() {
    mockHttpClient = MockAppHttpClient();
    mockCrashReporter = MockCrashReporter();
    datasource = SurahDatasourceImpl(
      httpClient: mockHttpClient,
      crashReporter: mockCrashReporter,
      baseUrl: 'https://equran.id/api/v2/surat',
    );
    when(() => mockCrashReporter.recordError(any(), any()))
        .thenAnswer((_) async {});
  });

  group('SurahDatasourceImpl.getSurah', () {
    test('returns List<SurahModel> with correct count on success', () async {
      when(
        () => mockHttpClient.get(
          url: any(named: 'url'),
          requestName: any(named: 'requestName'),
        ),
      ).thenAnswer((_) async => _kSurahMap);

      final result = await datasource.getSurah();

      expect(result, isA<List<SurahModel>>());
      expect(result.length, 2);
      expect(result[0].nomor, 1);
      expect(result[0].namaLatin, 'Al-Fatihah');
      expect(result[1].nomor, 2);
      expect(result[1].namaLatin, 'Al-Baqarah');
    });

    test('calls httpClient.get with correct URL and requestName', () async {
      when(
        () => mockHttpClient.get(
          url: any(named: 'url'),
          requestName: any(named: 'requestName'),
        ),
      ).thenAnswer((_) async => _kSurahMap);

      await datasource.getSurah();

      verify(
        () => mockHttpClient.get(
          url: 'https://equran.id/api/v2/surat',
          requestName: 'getSurah',
        ),
      ).called(1);
    });

    test('throws Exception and records to CrashReporter on DioException',
        () async {
      final dioException = DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: ''),
        message: 'Timeout',
      );

      when(
        () => mockHttpClient.get(
          url: any(named: 'url'),
          requestName: any(named: 'requestName'),
        ),
      ).thenThrow(dioException);

      await expectLater(datasource.getSurah(), throwsA(isA<Exception>()));

      verify(() => mockCrashReporter.recordError(dioException, any()))
          .called(1);
    });

    test(
        'throws ServerException and records to CrashReporter on generic exception',
        () async {
      const error = FormatException('Bad JSON');

      when(
        () => mockHttpClient.get(
          url: any(named: 'url'),
          requestName: any(named: 'requestName'),
        ),
      ).thenThrow(error);

      await expectLater(
        datasource.getSurah(),
        throwsA(isA<ServerException>()),
      );

      verify(() => mockCrashReporter.recordError(error, any())).called(1);
    });
  });
}
