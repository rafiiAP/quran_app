import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/error/exceptions.dart';
import 'package:quran_app/features/jadwal_sholat/data/datasources/jadwal_sholat_datasource.dart';
import 'package:quran_app/features/jadwal_sholat/data/models/jadwal_sholat_model.dart';

import '../../../../mocks.dart';

// ---------------------------------------------------------------------------
// JSON fixture
// ---------------------------------------------------------------------------

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

void main() {
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

  const tLatitude = -6.2;
  const tLongitude = 106.8;
  const tDate = '08-07-2026';

  group('JadwalSholatDatasourceImpl.getJadwalSholat', () {
    test('returns JadwalSholatModel with correct data on success', () async {
      when(
        () => mockHttpClient.get(
          url: any(named: 'url'),
          requestName: any(named: 'requestName'),
        ),
      ).thenAnswer((_) async => _kJadwalJson);

      final result = await datasource.getJadwalSholat(
        latitude: tLatitude,
        longitude: tLongitude,
        date: tDate,
      );

      expect(result, isA<JadwalSholatModel>());
      expect(result.fajr, '04:30');
      expect(result.sunrise, '05:51');
      expect(result.dhuhr, '11:53');
      expect(result.asr, '15:14');
      expect(result.maghrib, '17:55');
      expect(result.isha, '19:08');
      expect(result.imsak, '04:20');
    });

    test('calls httpClient.get with URL containing date, lat, lng', () async {
      when(
        () => mockHttpClient.get(
          url: any(named: 'url'),
          requestName: any(named: 'requestName'),
        ),
      ).thenAnswer((_) async => _kJadwalJson);

      await datasource.getJadwalSholat(
        latitude: tLatitude,
        longitude: tLongitude,
        date: tDate,
      );

      verify(
        () => mockHttpClient.get(
          url:
              'https://api.aladhan.com/v1/timings/$tDate?latitude=$tLatitude&longitude=$tLongitude',
          requestName: 'getJadwalSholat',
        ),
      ).called(1);
    });

    test('throws Exception and records to CrashReporter on DioException',
        () async {
      final dioException = DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: ''),
        message: 'No internet',
      );

      when(
        () => mockHttpClient.get(
          url: any(named: 'url'),
          requestName: any(named: 'requestName'),
        ),
      ).thenThrow(dioException);

      await expectLater(
        datasource.getJadwalSholat(
          latitude: tLatitude,
          longitude: tLongitude,
          date: tDate,
        ),
        throwsA(isA<Exception>()),
      );

      verify(() => mockCrashReporter.recordError(dioException, any()))
          .called(1);
    });

    test(
        'throws ServerException and records to CrashReporter on generic exception',
        () async {
      const error = FormatException('Invalid response format');

      when(
        () => mockHttpClient.get(
          url: any(named: 'url'),
          requestName: any(named: 'requestName'),
        ),
      ).thenThrow(error);

      await expectLater(
        datasource.getJadwalSholat(
          latitude: tLatitude,
          longitude: tLongitude,
          date: tDate,
        ),
        throwsA(isA<ServerException>()),
      );

      verify(() => mockCrashReporter.recordError(error, any())).called(1);
    });
  });
}
