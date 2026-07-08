import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/data/datasources/remote_datasource/remote_datasource.dart';
import 'package:quran_app/data/model/surah_model.dart';

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
        "teksArab": "بِسْمِ اللّٰهِ",
        "teksLatin": "Bismillah",
        "teksIndonesia": "Dengan nama Allah",
        "audio": {"01": "https://cdn.example.com/audio/1.mp3"}
      }
    ]
  }
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
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockAppHttpClient mockHttpClient;
  late MockCrashReporter mockCrashReporter;
  late RemoteDatasourceImpl datasource;

  setUp(() {
    mockHttpClient = MockAppHttpClient();
    mockCrashReporter = MockCrashReporter();
    datasource = RemoteDatasourceImpl(
      httpClient: mockHttpClient,
      crashReporter: mockCrashReporter,
    );
    // Default: crashReporter.recordError selalu sukses
    when(() => mockCrashReporter.recordError(any(), any()))
        .thenAnswer((_) async {});
  });

  // -------------------------------------------------------------------------
  // getSurah()
  // -------------------------------------------------------------------------

  group('getSurah()', () {
    test('returns List<SurahModel> on success', () async {
      when(() => mockHttpClient.get(
            url: any(named: 'url'),
            requestName: any(named: 'requestName'),
          )).thenAnswer((_) async => _kSurahJson);

      final result = await datasource.getSurah();

      expect(result, isA<List<SurahModel>>());
      expect(result.length, 1);
      expect(result.first.nomor, 1);
      expect(result.first.namaLatin, 'Al-Fatihah');
    });

    test('calls httpClient with correct URL', () async {
      when(() => mockHttpClient.get(
            url: any(named: 'url'),
            requestName: any(named: 'requestName'),
          )).thenAnswer((_) async => _kSurahJson);

      await datasource.getSurah();

      verify(() => mockHttpClient.get(
            url: 'https://equran.id/api/v2/surat',
            requestName: 'getSurah',
          )).called(1);
    });

    test('records DioException to CrashReporter and throws Exception',
        () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        message: 'timeout',
      );
      when(() => mockHttpClient.get(
            url: any(named: 'url'),
            requestName: any(named: 'requestName'),
          )).thenThrow(dioException);

      await expectLater(datasource.getSurah(), throwsA(isA<Exception>()));

      verify(() => mockCrashReporter.recordError(dioException, any()))
          .called(1);
    });

    test('records generic Exception to CrashReporter and rethrows', () async {
      final genericError = Exception('unknown');
      when(() => mockHttpClient.get(
            url: any(named: 'url'),
            requestName: any(named: 'requestName'),
          )).thenThrow(genericError);

      await expectLater(datasource.getSurah(), throwsA(isA<Exception>()));

      verify(() => mockCrashReporter.recordError(genericError, any()))
          .called(1);
    });
  });

  // -------------------------------------------------------------------------
  // getDetailSurah()
  // -------------------------------------------------------------------------

  group('getDetailSurah()', () {
    test('returns DetailModel on success', () async {
      when(() => mockHttpClient.get(
            url: any(named: 'url'),
            requestName: any(named: 'requestName'),
          )).thenAnswer((_) async => _kDetailJson);

      final result = await datasource.getDetailSurah(nomor: 1);

      expect(result.nomor, 1);
      expect(result.namaLatin, 'Al-Fatihah');
      expect(result.ayat.length, 1);
    });

    test('calls httpClient with nomor in URL', () async {
      when(() => mockHttpClient.get(
            url: any(named: 'url'),
            requestName: any(named: 'requestName'),
          )).thenAnswer((_) async => _kDetailJson);

      await datasource.getDetailSurah(nomor: 5);

      verify(() => mockHttpClient.get(
            url: 'https://equran.id/api/v2/surat/5',
            requestName: 'getDetailSurah',
          )).called(1);
    });

    test('records DioException and throws Exception', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        message: 'connection error',
      );
      when(() => mockHttpClient.get(
            url: any(named: 'url'),
            requestName: any(named: 'requestName'),
          )).thenThrow(dioException);

      await expectLater(
          datasource.getDetailSurah(nomor: 1), throwsA(isA<Exception>()));

      verify(() => mockCrashReporter.recordError(dioException, any()))
          .called(1);
    });

    test('records generic Exception to CrashReporter and rethrows', () async {
      final genericError = Exception('parse error');
      when(() => mockHttpClient.get(
            url: any(named: 'url'),
            requestName: any(named: 'requestName'),
          )).thenThrow(genericError);

      await expectLater(
          datasource.getDetailSurah(nomor: 1), throwsA(isA<Exception>()));

      verify(() => mockCrashReporter.recordError(genericError, any()))
          .called(1);
    });
  });

  // -------------------------------------------------------------------------
  // getJadwalSholat()
  // -------------------------------------------------------------------------

  group('getJadwalSholat()', () {
    test('returns JadwalSholatModel on success', () async {
      when(() => mockHttpClient.get(
            url: any(named: 'url'),
            requestName: any(named: 'requestName'),
          )).thenAnswer((_) async => _kJadwalJson);

      final result = await datasource.getJadwalSholat(
        latitude: -6.2,
        longitude: 106.8,
        date: '08-07-2026',
      );

      expect(result.fajr, '04:30');
      expect(result.isha, '19:08');
    });

    test('calls httpClient with URL containing lat, lng, date', () async {
      when(() => mockHttpClient.get(
            url: any(named: 'url'),
            requestName: any(named: 'requestName'),
          )).thenAnswer((_) async => _kJadwalJson);

      await datasource.getJadwalSholat(
        latitude: -6.2,
        longitude: 106.8,
        date: '08-07-2026',
      );

      final captured = verify(() => mockHttpClient.get(
            url: captureAny(named: 'url'),
            requestName: any(named: 'requestName'),
          )).captured;

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
      when(() => mockHttpClient.get(
            url: any(named: 'url'),
            requestName: any(named: 'requestName'),
          )).thenThrow(dioException);

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
      when(() => mockHttpClient.get(
            url: any(named: 'url'),
            requestName: any(named: 'requestName'),
          )).thenThrow(genericError);

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

  // -------------------------------------------------------------------------
  // Property test
  // -------------------------------------------------------------------------

  group('Property Tests', () {
    test('Property: getDetailSurah always passes nomor in URL', () async {
      // For any valid surah number (1-114), URL must contain that number.
      for (int nomor = 1; nomor <= 114; nomor++) {
        when(() => mockHttpClient.get(
              url: any(named: 'url'),
              requestName: any(named: 'requestName'),
            )).thenAnswer((_) async => _kDetailJson);

        await datasource.getDetailSurah(nomor: nomor);

        final captured = verify(() => mockHttpClient.get(
              url: captureAny(named: 'url'),
              requestName: any(named: 'requestName'),
            )).captured;

        final url = captured.first as String;
        expect(url, contains('/$nomor'),
            reason: 'URL harus mengandung /$nomor untuk nomor=$nomor');
      }
    });
  });
}
