import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/features/surah/data/datasources/surah_datasource.dart';
import 'package:quran_app/features/jadwal_sholat/data/datasources/jadwal_sholat_datasource.dart';
import 'package:quran_app/features/surah/data/models/surah_model.dart';

import '../../mocks.dart';

// ---------------------------------------------------------------------------
// Minimal JSON fixtures
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
    }
  ]
}
''';

const _kJadwalJson = '''
{
  "code": 200,
  "status": "OK",
  "data": {
    "timings": {
      "Fajr": "04:30",
      "Sunrise": "05:51",
      "Dhuhr": "11:53",
      "Asr": "15:14",
      "Sunset": "17:55",
      "Maghrib": "17:55",
      "Isha": "19:08",
      "Imsak": "04:20",
      "Midnight": "23:53",
      "Firstthird": "21:51",
      "Lastthird": "01:54"
    }
  }
}
''';

// ---------------------------------------------------------------------------
// Tests — SurahDatasourceImpl
// ---------------------------------------------------------------------------

void main() {
  group('SurahDatasourceImpl', () {
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

    group('getSurah()', () {
      test('returns List<SurahModel> on success', () async {
        when(
          () => mockHttpClient.get(
            url: any(named: 'url'),
            requestName: any(named: 'requestName'),
          ),
        ).thenAnswer((_) async => _kSurahJson);

        final result = await datasource.getSurah();

        expect(result, isA<List<SurahModel>>());
        expect(result.length, 1);
        expect(result.first.nomor, 1);
        expect(result.first.namaLatin, 'Al-Fatihah');
      });

      test('calls httpClient with correct URL', () async {
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

      test('records DioException to CrashReporter and throws Exception',
          () async {
        final dioException = DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'timeout',
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

      test('records generic Exception to CrashReporter and rethrows', () async {
        final genericError = Exception('unknown');
        when(
          () => mockHttpClient.get(
            url: any(named: 'url'),
            requestName: any(named: 'requestName'),
          ),
        ).thenThrow(genericError);

        await expectLater(datasource.getSurah(), throwsA(isA<Exception>()));

        verify(() => mockCrashReporter.recordError(genericError, any()))
            .called(1);
      });
    });
  });

  // -------------------------------------------------------------------------
  // Tests — JadwalSholatDatasourceImpl
  // -------------------------------------------------------------------------

  group('JadwalSholatDatasourceImpl', () {
    late MockAppHttpClient mockHttpClient;
    late MockCrashReporter mockCrashReporter;
    late JadwalSholatDatasourceImpl datasource;

    setUp(() {
      mockHttpClient = MockAppHttpClient();
      mockCrashReporter = MockCrashReporter();
      datasource = JadwalSholatDatasourceImpl(
        httpClient: mockHttpClient,
        crashReporter: mockCrashReporter,
        baseUrl: 'https://api.aladhan.com/v1/timings',
      );
      when(() => mockCrashReporter.recordError(any(), any()))
          .thenAnswer((_) async {});
    });

    test('returns JadwalSholatModel on success', () async {
      when(
        () => mockHttpClient.get(
          url: any(named: 'url'),
          requestName: any(named: 'requestName'),
        ),
      ).thenAnswer((_) async => _kJadwalJson);

      final result = await datasource.getJadwalSholat(
        latitude: -6.2,
        longitude: 106.8,
        date: '08-07-2026',
      );

      expect(result.fajr, '04:30');
      expect(result.isha, '19:08');
    });

    test('calls httpClient with URL containing lat, lng, date', () async {
      when(
        () => mockHttpClient.get(
          url: any(named: 'url'),
          requestName: any(named: 'requestName'),
        ),
      ).thenAnswer((_) async => _kJadwalJson);

      await datasource.getJadwalSholat(
        latitude: -6.2,
        longitude: 106.8,
        date: '08-07-2026',
      );

      final captured = verify(
        () => mockHttpClient.get(
          url: captureAny(named: 'url'),
          requestName: any(named: 'requestName'),
        ),
      ).captured;

      final url = captured.first as String;
      expect(url, contains('08-07-2026'));
      expect(url, contains('-6.2'));
      expect(url, contains('106.8'));
    });

    test('records DioException and throws Exception', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        message: 'no internet',
      );
      when(
        () => mockHttpClient.get(
          url: any(named: 'url'),
          requestName: any(named: 'requestName'),
        ),
      ).thenThrow(dioException);

      await expectLater(
        datasource.getJadwalSholat(
          latitude: -6.2,
          longitude: 106.8,
          date: '08-07-2026',
        ),
        throwsA(isA<Exception>()),
      );

      verify(() => mockCrashReporter.recordError(dioException, any()))
          .called(1);
    });

    test('records generic Exception to CrashReporter and rethrows', () async {
      final genericError = Exception('parse error');
      when(
        () => mockHttpClient.get(
          url: any(named: 'url'),
          requestName: any(named: 'requestName'),
        ),
      ).thenThrow(genericError);

      await expectLater(
        datasource.getJadwalSholat(
          latitude: -6.2,
          longitude: 106.8,
          date: '08-07-2026',
        ),
        throwsA(isA<Exception>()),
      );

      verify(() => mockCrashReporter.recordError(genericError, any()))
          .called(1);
    });
  });
}
