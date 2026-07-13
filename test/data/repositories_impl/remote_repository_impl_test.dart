import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/data/model/detail_model.dart';
import 'package:quran_app/data/repositories_impl/remote_repository_impl.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';
import 'package:quran_app/domain/repositories/remote_repository.dart';

import '../../mocks.dart';
import '../../fixtures/surah_fixture.dart';
import '../../fixtures/jadwal_sholat_fixture.dart';
import '../../helpers/generators.dart';

void main() {
  late MockRemoteDatasource mockDatasource;
  late RemoteRepositoryImpl repositoryImpl;

  setUp(() {
    mockDatasource = MockRemoteDatasource();
    repositoryImpl = RemoteRepositoryImpl(quranDatasource: mockDatasource);
  });

  group('getSurah()', () {
    test('success: returns Right(List<SurahEntity>) with same count', () async {
      // Arrange
      when(() => mockDatasource.getSurah())
          .thenAnswer((_) async => [kSurahModel]);

      // Act
      final result = await repositoryImpl.getSurah();

      // Assert
      expect(result, isA<Right<Failure, List<SurahEntity>>>());
      result.fold(
        (failure) => fail('should be Right'),
        (data) => expect(data.length, 1),
      );
      verify(() => mockDatasource.getSurah()).called(1);
    });

    test('success: each entity has correct field values from toEntity()',
        () async {
      // Arrange
      when(() => mockDatasource.getSurah())
          .thenAnswer((_) async => [kSurahModel]);

      // Act
      final result = await repositoryImpl.getSurah();

      // Assert
      result.fold(
        (failure) => fail('should be Right'),
        (data) {
          final entity = data.first;
          expect(entity.nomor, kSurahModel.nomor);
          expect(entity.nama, kSurahModel.nama);
          expect(entity.namaLatin, kSurahModel.namaLatin);
          expect(entity.jumlahAyat, kSurahModel.jumlahAyat);
          expect(entity.tempatTurun, kSurahModel.tempatTurun);
          expect(entity.arti, kSurahModel.arti);
          expect(entity.deskripsi, kSurahModel.deskripsi);
          expect(entity.audioFull, kSurahModel.audioFull);
        },
      );
    });

    test('DioException: returns Left(ConnectionFailure) with error message',
        () async {
      // Arrange
      when(() => mockDatasource.getSurah()).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          message: 'timeout',
        ),
      );

      // Act
      final result = await repositoryImpl.getSurah();

      // Assert
      expect(result, isA<Left<Failure, List<SurahEntity>>>());
      result.fold(
        (failure) {
          expect(failure, isA<ConnectionFailure>());
          expect(failure.message, 'timeout');
        },
        (_) => fail('should be Left'),
      );
    });

    test('generic Exception: returns Left(ServerFailure) with e.toString()',
        () async {
      // Arrange
      when(() => mockDatasource.getSurah())
          .thenThrow(Exception('unknown error'));

      // Act
      final result = await repositoryImpl.getSurah();

      // Assert
      expect(result, isA<Left<Failure, List<SurahEntity>>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, Exception('unknown error').toString());
        },
        (_) => fail('should be Left'),
      );
    });
  });

  group('getDetailSurah()', () {
    const tDetailModel = DetailModel(
      nomor: 1,
      nama: 'سُورَةُ الْفَاتِحَةِ',
      namaLatin: 'Al-Fatihah',
      jumlahAyat: 7,
      tempatTurun: 'Mekah',
      arti: 'Pembuka',
      deskripsi: 'Surah pembuka Al-Quran',
      audioFull: {
        '01': 'https://cdn.islamic.network/quran/audio/1/ar.alafasy/1.mp3',
      },
      ayat: [
        AyatDetailModel(
          nomorAyat: 1,
          teksArab: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
          teksLatin: 'Bismillāhir-raḥmānir-raḥīm',
          teksIndonesia: 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang',
          audio: {
            '01': 'https://cdn.islamic.network/quran/audio/1/ar.alafasy/1.mp3',
          },
        ),
      ],
    );

    test('success: returns Right(DetailEntity) with correct nomor', () async {
      // Arrange
      when(() => mockDatasource.getDetailSurah(nomor: 1))
          .thenAnswer((_) async => tDetailModel);

      // Act
      final result = await repositoryImpl.getDetailSurah(nomor: 1);

      // Assert
      expect(result, isA<Right<Failure, DetailEntity>>());
      result.fold(
        (failure) => fail('should be Right'),
        (data) {
          expect(data.nomor, 1);
          expect(data.namaLatin, 'Al-Fatihah');
          expect(data.ayat.length, tDetailModel.ayat.length);
        },
      );
      verify(() => mockDatasource.getDetailSurah(nomor: 1)).called(1);
    });

    test('DioException: returns Left(ConnectionFailure) with error message',
        () async {
      // Arrange
      when(() => mockDatasource.getDetailSurah(nomor: any(named: 'nomor')))
          .thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          message: 'timeout',
        ),
      );

      // Act
      final result = await repositoryImpl.getDetailSurah(nomor: 1);

      // Assert
      expect(result, isA<Left<Failure, DetailEntity>>());
      result.fold(
        (failure) {
          expect(failure, isA<ConnectionFailure>());
          expect(failure.message, 'timeout');
        },
        (_) => fail('should be Left'),
      );
    });

    test('generic Exception: returns Left(ServerFailure) with e.toString()',
        () async {
      // Arrange
      when(() => mockDatasource.getDetailSurah(nomor: any(named: 'nomor')))
          .thenThrow(Exception('unknown error'));

      // Act
      final result = await repositoryImpl.getDetailSurah(nomor: 1);

      // Assert
      expect(result, isA<Left<Failure, DetailEntity>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, Exception('unknown error').toString());
        },
        (_) => fail('should be Left'),
      );
    });
  });

  group('getJadwalSholat()', () {
    test('success: returns Right(JadwalSholatEntity) with all fields',
        () async {
      // Arrange
      when(
        () => mockDatasource.getJadwalSholat(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
          date: any(named: 'date'),
        ),
      ).thenAnswer((_) async => kJadwalSholatModel);

      // Act
      final result = await repositoryImpl.getJadwalSholat(
        latitude: -6.2,
        longitude: 106.8,
        date: '2024-01-15',
      );

      // Assert
      expect(result, isA<Right<Failure, JadwalSholatEntity>>());
      result.fold(
        (failure) => fail('should be Right'),
        (data) {
          expect(data.fajr, kJadwalSholatModel.fajr);
          expect(data.sunrise, kJadwalSholatModel.sunrise);
          expect(data.dhuhr, kJadwalSholatModel.dhuhr);
          expect(data.asr, kJadwalSholatModel.asr);
          expect(data.sunset, kJadwalSholatModel.sunset);
          expect(data.maghrib, kJadwalSholatModel.maghrib);
          expect(data.isha, kJadwalSholatModel.isha);
          expect(data.imsak, kJadwalSholatModel.imsak);
          expect(data.midnight, kJadwalSholatModel.midnight);
          expect(data.firstthird, kJadwalSholatModel.firstthird);
          expect(data.lastthird, kJadwalSholatModel.lastthird);
        },
      );
      verify(
        () => mockDatasource.getJadwalSholat(
          latitude: -6.2,
          longitude: 106.8,
          date: '2024-01-15',
        ),
      ).called(1);
    });

    test('DioException: returns Left(ConnectionFailure) with error message',
        () async {
      // Arrange
      when(
        () => mockDatasource.getJadwalSholat(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
          date: any(named: 'date'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          message: 'timeout',
        ),
      );

      // Act
      final result = await repositoryImpl.getJadwalSholat(
        latitude: -6.2,
        longitude: 106.8,
        date: '2024-01-15',
      );

      // Assert
      expect(result, isA<Left<Failure, JadwalSholatEntity>>());
      result.fold(
        (failure) {
          expect(failure, isA<ConnectionFailure>());
          expect(failure.message, 'timeout');
        },
        (_) => fail('should be Left'),
      );
    });

    test('generic Exception: returns Left(ServerFailure) with e.toString()',
        () async {
      // Arrange
      when(
        () => mockDatasource.getJadwalSholat(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
          date: any(named: 'date'),
        ),
      ).thenThrow(Exception('unknown error'));

      // Act
      final result = await repositoryImpl.getJadwalSholat(
        latitude: -6.2,
        longitude: 106.8,
        date: '2024-01-15',
      );

      // Assert
      expect(result, isA<Left<Failure, JadwalSholatEntity>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, Exception('unknown error').toString());
        },
        (_) => fail('should be Left'),
      );
    });
  });

  group('Property 10: RemoteRepositoryImpl Success Mapping', () {
    test(
        'for any List<SurahModel>, returns Right with same count and identical fields',
        () async {
      // Feature: unit-testing, Property 10: success mapping
      // **Validates: Requirements 8.1, 8.2**
      for (int i = 0; i < 100; i++) {
        final listSize = i % 5; // 0 to 4 elements
        final models =
            List.generate(listSize, (_) => generateRandomSurahModel());

        when(() => mockDatasource.getSurah()).thenAnswer((_) async => models);

        final result = await repositoryImpl.getSurah();

        result.fold(
          (failure) => fail('should be Right'),
          (entities) {
            expect(entities.length, models.length);
            for (int j = 0; j < entities.length; j++) {
              expect(entities[j].nomor, models[j].nomor);
              expect(entities[j].nama, models[j].nama);
              expect(entities[j].namaLatin, models[j].namaLatin);
              expect(entities[j].jumlahAyat, models[j].jumlahAyat);
              expect(entities[j].tempatTurun, models[j].tempatTurun);
              expect(entities[j].arti, models[j].arti);
              expect(entities[j].deskripsi, models[j].deskripsi);
              expect(entities[j].audioFull, models[j].audioFull);
            }
          },
        );
      }
    });
  });
}
