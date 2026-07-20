import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/error/exceptions.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/jadwal_sholat/data/models/jadwal_sholat_model.dart';
import 'package:quran_app/features/jadwal_sholat/data/repositories/jadwal_sholat_repository_impl.dart';

import '../../../../fixtures/jadwal_sholat_fixture.dart';
import '../../../../mocks.dart';

void main() {
  late MockJadwalSholatDatasource mockDatasource;
  late MockConnectivityService mockConnectivityService;
  late JadwalSholatRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockJadwalSholatDatasource();
    mockConnectivityService = MockConnectivityService();
    repository = JadwalSholatRepositoryImpl(
      datasource: mockDatasource,
      connectivityService: mockConnectivityService,
    );

    // Default: online
    when(() => mockConnectivityService.hasConnection())
        .thenAnswer((_) async => true);
  });

  const tLatitude = -6.2;
  const tLongitude = 106.8;
  const tDate = '08-07-2026';

  group('JadwalSholatRepositoryImpl.getJadwalSholat', () {
    test('returns Right with mapped JadwalSholatEntity on success', () async {
      when(
        () => mockDatasource.getJadwalSholat(
          latitude: tLatitude,
          longitude: tLongitude,
          date: tDate,
        ),
      ).thenAnswer((_) async => kJadwalSholatModel);

      final result = await repository.getJadwalSholat(
        latitude: tLatitude,
        longitude: tLongitude,
        date: tDate,
      );

      expect(result.isRight(), isTrue);
      final entity = result.match((_) => null, (d) => d);
      expect(entity!.fajr, '04:30');
      expect(entity.dhuhr, '11:53');
      expect(entity.isha, '19:08');
      expect(entity.maghrib, '17:55');
    });

    test('verifies correct parameters passed to datasource', () async {
      when(
        () => mockDatasource.getJadwalSholat(
          latitude: tLatitude,
          longitude: tLongitude,
          date: tDate,
        ),
      ).thenAnswer((_) async => kJadwalSholatModel);

      await repository.getJadwalSholat(
        latitude: tLatitude,
        longitude: tLongitude,
        date: tDate,
      );

      verify(
        () => mockDatasource.getJadwalSholat(
          latitude: tLatitude,
          longitude: tLongitude,
          date: tDate,
        ),
      ).called(1);
    });

    test('returns Left(ConnectionFailure) when ConnectionException is thrown',
        () async {
      when(
        () => mockDatasource.getJadwalSholat(
          latitude: tLatitude,
          longitude: tLongitude,
          date: tDate,
        ),
      ).thenThrow(
        const ConnectionException('Connection refused'),
      );

      final result = await repository.getJadwalSholat(
        latitude: tLatitude,
        longitude: tLongitude,
        date: tDate,
      );

      expect(result.isLeft(), isTrue);
      final failure = result.match((f) => f, (_) => null);
      expect(failure, isA<ConnectionFailure>());
      expect(failure!.message, 'Connection refused');
    });

    test('returns Left(ServerFailure) when ServerException is thrown',
        () async {
      when(
        () => mockDatasource.getJadwalSholat(
          latitude: tLatitude,
          longitude: tLongitude,
          date: tDate,
        ),
      ).thenThrow(
        const ServerException('Parse error'),
      );

      final result = await repository.getJadwalSholat(
        latitude: tLatitude,
        longitude: tLongitude,
        date: tDate,
      );

      expect(result.isLeft(), isTrue);
      final failure = result.match((f) => f, (_) => null);
      expect(failure, isA<ServerFailure>());
      expect(failure!.message, 'Parse error');
    });

    test('returns Left(ServerFailure) when generic exception is thrown',
        () async {
      when(
        () => mockDatasource.getJadwalSholat(
          latitude: tLatitude,
          longitude: tLongitude,
          date: tDate,
        ),
      ).thenThrow(Exception('Unexpected parsing error'));

      final result = await repository.getJadwalSholat(
        latitude: tLatitude,
        longitude: tLongitude,
        date: tDate,
      );

      expect(result.isLeft(), isTrue);
      final failure = result.match((f) => f, (_) => null);
      expect(failure, isA<ServerFailure>());
      expect(failure!.message, contains('Unexpected parsing error'));
    });

    test('maps model toEntity correctly preserving all timing fields',
        () async {
      const customModel = JadwalSholatModel(
        fajr: '05:00',
        sunrise: '06:15',
        dhuhr: '12:00',
        asr: '15:30',
        sunset: '18:00',
        maghrib: '18:05',
        isha: '19:30',
        imsak: '04:50',
        midnight: '00:00',
        firstthird: '22:00',
        lastthird: '02:00',
      );

      when(
        () => mockDatasource.getJadwalSholat(
          latitude: tLatitude,
          longitude: tLongitude,
          date: tDate,
        ),
      ).thenAnswer((_) async => customModel);

      final result = await repository.getJadwalSholat(
        latitude: tLatitude,
        longitude: tLongitude,
        date: tDate,
      );

      expect(result.isRight(), isTrue);
      final entity = result.match((_) => null, (d) => d);
      expect(entity!.fajr, '05:00');
      expect(entity.sunrise, '06:15');
      expect(entity.dhuhr, '12:00');
      expect(entity.asr, '15:30');
      expect(entity.sunset, '18:00');
      expect(entity.maghrib, '18:05');
      expect(entity.isha, '19:30');
      expect(entity.imsak, '04:50');
      expect(entity.midnight, '00:00');
      expect(entity.firstthird, '22:00');
      expect(entity.lastthird, '02:00');
    });

    test('returns Left(ConnectionFailure) immediately when device is offline',
        () async {
      when(() => mockConnectivityService.hasConnection())
          .thenAnswer((_) async => false);

      final result = await repository.getJadwalSholat(
        latitude: tLatitude,
        longitude: tLongitude,
        date: tDate,
      );

      expect(result.isLeft(), isTrue);
      final failure = result.match((f) => f, (_) => null);
      expect(failure, isA<ConnectionFailure>());
      expect(failure!.message, contains('koneksi internet'));
      verifyNever(
        () => mockDatasource.getJadwalSholat(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
          date: any(named: 'date'),
        ),
      );
    });
  });
}
