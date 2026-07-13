import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';
import 'package:quran_app/domain/repositories/remote_repository.dart';
import 'package:quran_app/domain/use_case/remote_usecase.dart';

import '../../mocks.dart';
import '../../fixtures/surah_fixture.dart';
import '../../helpers/generators.dart';

void main() {
  late MockRemoteRepository mockRepository;
  late RemoteUsecase usecase;

  setUp(() {
    mockRepository = MockRemoteRepository();
    usecase = RemoteUsecase(mockRepository);
  });

  group('execute()', () {
    final tSurahList = [kSurahEntity];

    test('should return Right(list) from repository and call getSurah() once',
        () async {
      // arrange
      when(() => mockRepository.getSurah())
          .thenAnswer((_) async => Right(tSurahList));

      // act
      final result = await usecase.execute();

      // assert
      expect(result, Right<Failure, List<SurahEntity>>(tSurahList));
      verify(() => mockRepository.getSurah()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('getDetailSurah()', () {
    const tNomor = 36;
    const tDetailEntity = DetailEntity(
      nomor: 36,
      nama: 'يسٓ',
      namaLatin: 'Yasin',
      jumlahAyat: 83,
      tempatTurun: 'Mekah',
      arti: 'Yasin',
      deskripsi: 'Surah Yasin',
      audioFull: {'01': 'https://cdn.example.com/36.mp3'},
      ayat: [
        AyatDetailEntity(
          nomorAyat: 1,
          teksArab: 'يسٓ',
          teksLatin: 'Yā Sīn.',
          teksIndonesia: 'Ya Sin.',
          audio: {'01': 'https://cdn.example.com/36/1.mp3'},
        ),
      ],
    );

    test('should forward argument nomor exactly to repository', () async {
      // arrange
      when(() => mockRepository.getDetailSurah(nomor: tNomor))
          .thenAnswer((_) async => const Right(tDetailEntity));

      // act
      final result = await usecase.getDetailSurah(nomor: tNomor);

      // assert
      expect(result, const Right<Failure, DetailEntity>(tDetailEntity));
      verify(() => mockRepository.getDetailSurah(nomor: tNomor)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('getJadwalSholat()', () {
    const tLatitude = -6.2088;
    const tLongitude = 106.8456;
    const tDate = '2024-01-15';
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

    test('should forward all three arguments exactly to repository', () async {
      // arrange
      when(
        () => mockRepository.getJadwalSholat(
          latitude: tLatitude,
          longitude: tLongitude,
          date: tDate,
        ),
      ).thenAnswer(
        (_) async =>
            const Right<Failure, JadwalSholatEntity>(tJadwalSholatEntity),
      );

      // act
      final result = await usecase.getJadwalSholat(
        latitude: tLatitude,
        longitude: tLongitude,
        date: tDate,
      );

      // assert
      expect(
        result,
        const Right<Failure, JadwalSholatEntity>(tJadwalSholatEntity),
      );
      verify(
        () => mockRepository.getJadwalSholat(
          latitude: tLatitude,
          longitude: tLongitude,
          date: tDate,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('Left pass-through', () {
    const tServerFailure = ServerFailure('Server error occurred');

    test(
        'should return Left(ServerFailure) from execute() without modification',
        () async {
      // arrange
      when(() => mockRepository.getSurah())
          .thenAnswer((_) async => const Left(tServerFailure));

      // act
      final result = await usecase.execute();

      // assert
      expect(result, const Left<Failure, List<SurahEntity>>(tServerFailure));
      verify(() => mockRepository.getSurah()).called(1);
    });

    test(
        'should return Left(ServerFailure) from getDetailSurah() without modification',
        () async {
      // arrange
      when(() => mockRepository.getDetailSurah(nomor: any(named: 'nomor')))
          .thenAnswer((_) async => const Left(tServerFailure));

      // act
      final result = await usecase.getDetailSurah(nomor: 1);

      // assert
      expect(result, const Left<Failure, DetailEntity>(tServerFailure));
    });

    test(
        'should return Left(ConnectionFailure) from getJadwalSholat() without modification',
        () async {
      const tConnectionFailure = ConnectionFailure('No internet connection');

      // arrange
      when(
        () => mockRepository.getJadwalSholat(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
          date: any(named: 'date'),
        ),
      ).thenAnswer((_) async => const Left(tConnectionFailure));

      // act
      final result = await usecase.getJadwalSholat(
        latitude: -6.2088,
        longitude: 106.8456,
        date: '2024-01-15',
      );

      // assert
      expect(
        result,
        const Left<Failure, JadwalSholatEntity>(tConnectionFailure),
      );
    });
  });

  group('Property 4: RemoteUsecase Pass-through Either', () {
    // Feature: unit-testing, Property 4: pass-through Either
    // **Validates: Requirements 3.1, 3.2, 3.3, 3.4, 3.5**

    test('execute() passes through Right(List<SurahEntity>) unchanged',
        () async {
      for (int i = 0; i < 100; i++) {
        final model = generateRandomSurahModel();
        final entity = model.toEntity();
        final expected = Right<Failure, List<SurahEntity>>([entity]);

        when(() => mockRepository.getSurah()).thenAnswer((_) async => expected);

        final result = await usecase.execute();
        expect(result, expected);
      }
    });

    test('execute() passes through Left(Failure) unchanged', () async {
      for (int i = 0; i < 100; i++) {
        final message =
            'Error message $i - ${String.fromCharCodes(List.generate(5, (_) => 97 + (i % 26)))}';
        final failures = [
          ServerFailure(message),
          ConnectionFailure(message),
          ResponseFailure(message),
        ];
        final failure = failures[i % 3];
        final expected = Left<Failure, List<SurahEntity>>(failure);

        when(() => mockRepository.getSurah()).thenAnswer((_) async => expected);

        final result = await usecase.execute();
        expect(result, expected);
      }
    });

    test('getDetailSurah() passes through Right(DetailEntity) unchanged',
        () async {
      for (int i = 0; i < 100; i++) {
        final model = generateRandomDetailModel();
        final entity = model.toEntity();
        final nomor = model.nomor;
        final expected = Right<Failure, DetailEntity>(entity);

        when(() => mockRepository.getDetailSurah(nomor: nomor))
            .thenAnswer((_) async => expected);

        final result = await usecase.getDetailSurah(nomor: nomor);
        expect(result, expected);
      }
    });

    test('getDetailSurah() passes through Left(Failure) unchanged', () async {
      for (int i = 0; i < 100; i++) {
        final message = 'Detail error $i';
        final failures = [
          ServerFailure(message),
          ConnectionFailure(message),
          ResponseFailure(message),
        ];
        final failure = failures[i % 3];
        final expected = Left<Failure, DetailEntity>(failure);

        when(() => mockRepository.getDetailSurah(nomor: any(named: 'nomor')))
            .thenAnswer((_) async => expected);

        final result = await usecase.getDetailSurah(nomor: i + 1);
        expect(result, expected);
      }
    });

    test('getJadwalSholat() passes through Right(JadwalSholatEntity) unchanged',
        () async {
      for (int i = 0; i < 100; i++) {
        final model = generateRandomJadwalSholatModel();
        final entity = model.toEntity();
        final latitude = -6.0 + (i * 0.1);
        final longitude = 106.0 + (i * 0.05);
        final date = '2024-01-${(i % 28 + 1).toString().padLeft(2, '0')}';
        final expected = Right<Failure, JadwalSholatEntity>(entity);

        when(
          () => mockRepository.getJadwalSholat(
            latitude: latitude,
            longitude: longitude,
            date: date,
          ),
        ).thenAnswer((_) async => expected);

        final result = await usecase.getJadwalSholat(
          latitude: latitude,
          longitude: longitude,
          date: date,
        );
        expect(result, expected);
      }
    });

    test('getJadwalSholat() passes through Left(Failure) unchanged', () async {
      for (int i = 0; i < 100; i++) {
        final message = 'Jadwal error $i';
        final failures = [
          ServerFailure(message),
          ConnectionFailure(message),
          ResponseFailure(message),
        ];
        final failure = failures[i % 3];
        final expected = Left<Failure, JadwalSholatEntity>(failure);

        when(
          () => mockRepository.getJadwalSholat(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => expected);

        final result = await usecase.getJadwalSholat(
          latitude: -6.2 + i,
          longitude: 106.8 + i,
          date: '2024-02-${(i % 28 + 1).toString().padLeft(2, '0')}',
        );
        expect(result, expected);
      }
    });
  });
}
