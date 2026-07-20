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

  const tParams = JadwalSholatParams(
    latitude: -6.2,
    longitude: 106.8,
    date: '08-07-2026',
  );

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
          latitude: tParams.latitude,
          longitude: tParams.longitude,
          date: tParams.date,
        ),
      ).thenAnswer(
        (_) async => const Right(tJadwalSholatEntity),
      );

      final result = await useCase.call(tParams);

      expect(result.isRight(), isTrue);
      final entity = result.match((_) => null, (d) => d);
      expect(entity, tJadwalSholatEntity);
      verify(
        () => mockRepository.getJadwalSholat(
          latitude: tParams.latitude,
          longitude: tParams.longitude,
          date: tParams.date,
        ),
      ).called(1);
    });

    test(
        'delegates to JadwalSholatRepository.getJadwalSholat and returns Left on failure',
        () async {
      when(
        () => mockRepository.getJadwalSholat(
          latitude: tParams.latitude,
          longitude: tParams.longitude,
          date: tParams.date,
        ),
      ).thenAnswer(
        (_) async => const Left(ConnectionFailure('No internet connection')),
      );

      final result = await useCase.call(tParams);

      expect(result.isLeft(), isTrue);
      final failure = result.match((f) => f, (_) => null);
      expect(failure, isA<ConnectionFailure>());
      expect(failure!.message, 'No internet connection');
      verify(
        () => mockRepository.getJadwalSholat(
          latitude: tParams.latitude,
          longitude: tParams.longitude,
          date: tParams.date,
        ),
      ).called(1);
    });

    test('passes all parameters correctly to repository', () async {
      const customParams = JadwalSholatParams(
        latitude: 35.6762,
        longitude: 139.6503,
        date: '25-12-2025',
      );

      when(
        () => mockRepository.getJadwalSholat(
          latitude: customParams.latitude,
          longitude: customParams.longitude,
          date: customParams.date,
        ),
      ).thenAnswer(
        (_) async => const Right(tJadwalSholatEntity),
      );

      await useCase.call(customParams);

      verify(
        () => mockRepository.getJadwalSholat(
          latitude: customParams.latitude,
          longitude: customParams.longitude,
          date: customParams.date,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
