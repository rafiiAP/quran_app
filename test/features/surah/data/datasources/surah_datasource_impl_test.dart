import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/error/exceptions.dart';
import 'package:quran_app/features/detail_surah/data/models/detail_model.dart';
import 'package:quran_app/features/surah/data/datasources/surah_datasource.dart';
import 'package:quran_app/features/surah/data/models/surah_model.dart';

import '../../../../mocks.dart';

// ---------------------------------------------------------------------------
// JSON fixtures
// ---------------------------------------------------------------------------

const _kSurahJson = '''
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
''';

const _kDetailJson = '''
{
  "code": 200,
  "message": "OK",
  "data": {
    "nomor": 1,
    "nama": "الفاتحة",
    "namaLatin": "Al-Fatihah",
    "jumlahAyat": 7,
    "tempatTurun": "Mekah",
    "arti": "Pembuka",
    "deskripsi": "Surah pertama",
    "audioFull": {"01": "https://cdn.example.com/1.mp3"},
    "ayat": [
      {
        "nomorAyat": 1,
        "teksArab": "بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ",
        "teksLatin": "Bismillaahir rahmaanir rahiim",
        "teksIndonesia": "Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.",
        "audio": {"01": "https://cdn.example.com/audio/1.mp3"}
      }
    ]
  }
}
''';

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
      ).thenAnswer((_) async => _kSurahJson);

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
      ).thenAnswer((_) async => _kSurahJson);

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

  group('SurahDatasourceImpl.getDetailSurah', () {
    test('returns DetailModel with correct data on success', () async {
      when(
        () => mockHttpClient.get(
          url: any(named: 'url'),
          requestName: any(named: 'requestName'),
        ),
      ).thenAnswer((_) async => _kDetailJson);

      final result = await datasource.getDetailSurah(nomor: 1);

      expect(result, isA<DetailModel>());
      expect(result.nomor, 1);
      expect(result.namaLatin, 'Al-Fatihah');
      expect(result.ayat.length, 1);
      expect(result.ayat.first.nomorAyat, 1);
    });

    test('calls httpClient.get with nomor appended to URL', () async {
      when(
        () => mockHttpClient.get(
          url: any(named: 'url'),
          requestName: any(named: 'requestName'),
        ),
      ).thenAnswer((_) async => _kDetailJson);

      await datasource.getDetailSurah(nomor: 42);

      verify(
        () => mockHttpClient.get(
          url: 'https://equran.id/api/v2/surat/42',
          requestName: 'getDetailSurah',
        ),
      ).called(1);
    });

    test('throws Exception and records to CrashReporter on DioException',
        () async {
      final dioException = DioException(
        type: DioExceptionType.receiveTimeout,
        requestOptions: RequestOptions(path: ''),
        message: 'Receive timeout',
      );

      when(
        () => mockHttpClient.get(
          url: any(named: 'url'),
          requestName: any(named: 'requestName'),
        ),
      ).thenThrow(dioException);

      await expectLater(
        datasource.getDetailSurah(nomor: 1),
        throwsA(isA<Exception>()),
      );

      verify(() => mockCrashReporter.recordError(dioException, any()))
          .called(1);
    });

    test(
        'throws ServerException and records to CrashReporter on generic exception',
        () async {
      final error = Exception('Unexpected error');

      when(
        () => mockHttpClient.get(
          url: any(named: 'url'),
          requestName: any(named: 'requestName'),
        ),
      ).thenThrow(error);

      await expectLater(
        datasource.getDetailSurah(nomor: 1),
        throwsA(isA<ServerException>()),
      );

      verify(() => mockCrashReporter.recordError(error, any())).called(1);
    });
  });
}
