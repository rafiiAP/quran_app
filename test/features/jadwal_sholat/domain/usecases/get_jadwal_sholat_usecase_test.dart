import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/jadwal_sholat/domain/entities/jadwal_sholat_entity.dart';
import 'package:quran_app/features/jadwal_sholat/domain/usecases/get_jadwal_sholat_usecase.dart';

import '../../../../mocks.dart';

void main() {
  late MockJadwalSholatRepository mockRepository;
  late GetJadwalSholatUseCase useCase;

  setUp(() {
    mockRepository = MockJadwalSholatRepository();
    useCase = GetJadwalSholatUseCase(mockRepository);
  });

  const tLatitude = -6.2;
  const tLongitude = 106.8;
  const tDate = '08-07-2026';

  const tJadwalSholatEntity = JadwalSholatEntity(
    fajr: '04:30',
    sunrise: '05:51',
    dhuhr: '11:53',
    asr: '15:14',
    sunset: '17:55',
    maghrib: '17:55',
    isha: '19:08',
    imsak: '04:20',
    midnight: '23:53',
    firstthird: '21:51',
    lastthird: '01:54',
  );

  group('GetJadwalSholatUseCase', () {
    test(
        'delegates to JadwalSholatRepository.getJadwalSholat and returns Right on success',
        () async {
      when(
        () => mockRepository.getJadwalSholat(
          latitude: tLatitude,
          longitude: tLongitude,
          date: tDate,
        ),
      ).thenAnswer(
        (_) async => const Right(tJadwalSholatEntity),
      );

      final result = await useCase.call(
        latitude: tLatitude,
        longitude: tLongitude,
        date: tDate,
      );

      expect(result.isRight(), isTrue);
      final entity = result.match((_) => null, (d) => d);
      expect(entity, tJadwalSholatEntity);
      verify(
        () => mockRepository.getJadwalSholat(
          latitude: tLatitude,
          longitude: tLongitude,
          date: tDate,
        ),
      ).called(1);
    });

    test(
        'delegates to JadwalSholatRepository.getJadwalSholat and returns Left on failure',
        () async {
      when(
        () => mockRepository.getJadwalSholat(
          latitude: tLatitude,
          longitude: tLongitude,
          date: tDate,
        ),
      ).thenAnswer(
        (_) async => const Left(ConnectionFailure('No internet connection')),
      );

      final result = await useCase.call(
        latitude: tLatitude,
        longitude: tLongitude,
        date: tDate,
      );

      expect(result.isLeft(), isTrue);
      final failure = result.match((f) => f, (_) => null);
      expect(failure, isA<ConnectionFailure>());
      expect(failure!.message, 'No internet connection');
      verify(
        () => mockRepository.getJadwalSholat(
          latitude: tLatitude,
          longitude: tLongitude,
          date: tDate,
        ),
      ).called(1);
    });

    test('passes all parameters correctly to repository', () async {
      const customLat = 35.6762;
      const customLng = 139.6503;
      const customDate = '25-12-2025';

      when(
        () => mockRepository.getJadwalSholat(
          latitude: customLat,
          longitude: customLng,
          date: customDate,
        ),
      ).thenAnswer(
        (_) async => const Right(tJadwalSholatEntity),
      );

      await useCase.call(
        latitude: customLat,
        longitude: customLng,
        date: customDate,
      );

      verify(
        () => mockRepository.getJadwalSholat(
          latitude: customLat,
          longitude: customLng,
          date: customDate,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
