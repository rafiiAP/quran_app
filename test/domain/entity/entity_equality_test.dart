import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/surah/domain/entities/surah_entity.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';
import 'package:quran_app/features/jadwal_sholat/domain/entities/jadwal_sholat_entity.dart';
import 'package:quran_app/core/error/failure.dart';

import '../../helpers/generators.dart';

void main() {
  group('SurahEntity', () {
    const surah1 = SurahEntity(
      nomor: 1,
      nama: 'سُورَةُ الْفَاتِحَةِ',
      namaLatin: 'Al-Fatihah',
      jumlahAyat: 7,
      tempatTurun: 'Mekah',
      arti: 'Pembuka',
      deskripsi: 'Surah pembuka Al-Quran',
      audioFull: {'01': 'https://cdn.example.com/1.mp3'},
    );

    const surah2 = SurahEntity(
      nomor: 1,
      nama: 'سُورَةُ الْفَاتِحَةِ',
      namaLatin: 'Al-Fatihah',
      jumlahAyat: 7,
      tempatTurun: 'Mekah',
      arti: 'Pembuka',
      deskripsi: 'Surah pembuka Al-Quran',
      audioFull: {'01': 'https://cdn.example.com/1.mp3'},
    );

    const surahDifferentNomor = SurahEntity(
      nomor: 2,
      nama: 'سُورَةُ الْفَاتِحَةِ',
      namaLatin: 'Al-Fatihah',
      jumlahAyat: 7,
      tempatTurun: 'Mekah',
      arti: 'Pembuka',
      deskripsi: 'Surah pembuka Al-Quran',
      audioFull: {'01': 'https://cdn.example.com/1.mp3'},
    );

    test('two instances with identical fields should be equal', () {
      expect(surah1, equals(surah2));
      expect(surah1 == surah2, isTrue);
    });

    test('two instances with different nomor should not be equal', () {
      expect(surah1, isNot(equals(surahDifferentNomor)));
      expect(surah1 == surahDifferentNomor, isFalse);
    });

    test('two instances with different namaLatin should not be equal', () {
      const surahDifferentNamaLatin = SurahEntity(
        nomor: 1,
        nama: 'سُورَةُ الْفَاتِحَةِ',
        namaLatin: 'Al-Baqarah',
        jumlahAyat: 7,
        tempatTurun: 'Mekah',
        arti: 'Pembuka',
        deskripsi: 'Surah pembuka Al-Quran',
        audioFull: {'01': 'https://cdn.example.com/1.mp3'},
      );
      expect(surah1 == surahDifferentNamaLatin, isFalse);
    });

    test('props contains all fields', () {
      expect(
        surah1.props,
        [
          1,
          'سُورَةُ الْفَاتِحَةِ',
          'Al-Fatihah',
          7,
          'Mekah',
          'Pembuka',
          'Surah pembuka Al-Quran',
          {'01': 'https://cdn.example.com/1.mp3'},
        ],
      );
    });
  });

  group('DetailEntity', () {
    const ayat1 = AyatDetailEntity(
      nomorAyat: 1,
      teksArab: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
      teksLatin: 'Bismillāhir-raḥmānir-raḥīm',
      teksIndonesia: 'Dengan nama Allah Yang Maha Pengasih',
      audio: {'01': 'https://cdn.example.com/ayat1.mp3'},
    );

    const ayat2 = AyatDetailEntity(
      nomorAyat: 2,
      teksArab: 'اَلْحَمْدُ لِلّٰهِ رَبِّ الْعٰلَمِيْنَ',
      teksLatin: 'Al-ḥamdu lillāhi rabbil-ʿālamīn',
      teksIndonesia: 'Segala puji bagi Allah, Tuhan seluruh alam',
      audio: {'01': 'https://cdn.example.com/ayat2.mp3'},
    );

    const detail1 = DetailEntity(
      nomor: 1,
      nama: 'سُورَةُ الْفَاتِحَةِ',
      namaLatin: 'Al-Fatihah',
      jumlahAyat: 7,
      tempatTurun: 'Mekah',
      arti: 'Pembuka',
      deskripsi: 'Surah pembuka Al-Quran',
      audioFull: {'01': 'https://cdn.example.com/1.mp3'},
      ayat: [ayat1, ayat2],
    );

    const detail2 = DetailEntity(
      nomor: 1,
      nama: 'سُورَةُ الْفَاتِحَةِ',
      namaLatin: 'Al-Fatihah',
      jumlahAyat: 7,
      tempatTurun: 'Mekah',
      arti: 'Pembuka',
      deskripsi: 'Surah pembuka Al-Quran',
      audioFull: {'01': 'https://cdn.example.com/1.mp3'},
      ayat: [ayat1, ayat2],
    );

    test(
        'two instances with identical fields including ayat list should be equal',
        () {
      expect(detail1, equals(detail2));
      expect(detail1 == detail2, isTrue);
    });

    test('two instances with different ayat list should not be equal', () {
      const detailDifferentAyat = DetailEntity(
        nomor: 1,
        nama: 'سُورَةُ الْفَاتِحَةِ',
        namaLatin: 'Al-Fatihah',
        jumlahAyat: 7,
        tempatTurun: 'Mekah',
        arti: 'Pembuka',
        deskripsi: 'Surah pembuka Al-Quran',
        audioFull: {'01': 'https://cdn.example.com/1.mp3'},
        ayat: [ayat1], // only one ayat instead of two
      );
      expect(detail1 == detailDifferentAyat, isFalse);
    });

    test('two instances with different nomor should not be equal', () {
      const detailDifferentNomor = DetailEntity(
        nomor: 2,
        nama: 'سُورَةُ الْفَاتِحَةِ',
        namaLatin: 'Al-Fatihah',
        jumlahAyat: 7,
        tempatTurun: 'Mekah',
        arti: 'Pembuka',
        deskripsi: 'Surah pembuka Al-Quran',
        audioFull: {'01': 'https://cdn.example.com/1.mp3'},
        ayat: [ayat1, ayat2],
      );
      expect(detail1 == detailDifferentNomor, isFalse);
    });

    test('AyatDetailEntity with identical fields should be equal', () {
      const ayat1Copy = AyatDetailEntity(
        nomorAyat: 1,
        teksArab: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
        teksLatin: 'Bismillāhir-raḥmānir-raḥīm',
        teksIndonesia: 'Dengan nama Allah Yang Maha Pengasih',
        audio: {'01': 'https://cdn.example.com/ayat1.mp3'},
      );
      expect(ayat1, equals(ayat1Copy));
      expect(ayat1 == ayat1Copy, isTrue);
    });

    test('AyatDetailEntity with different nomorAyat should not be equal', () {
      const ayatDifferent = AyatDetailEntity(
        nomorAyat: 99,
        teksArab: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
        teksLatin: 'Bismillāhir-raḥmānir-raḥīm',
        teksIndonesia: 'Dengan nama Allah Yang Maha Pengasih',
        audio: {'01': 'https://cdn.example.com/ayat1.mp3'},
      );
      expect(ayat1 == ayatDifferent, isFalse);
    });

    test('AyatDetailEntity.props contains all fields', () {
      expect(
        ayat1.props,
        [
          1,
          'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
          'Bismillāhir-raḥmānir-raḥīm',
          'Dengan nama Allah Yang Maha Pengasih',
          {'01': 'https://cdn.example.com/ayat1.mp3'},
        ],
      );
    });
  });

  group('JadwalSholatEntity', () {
    const jadwal1 = JadwalSholatEntity(
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

    const jadwal2 = JadwalSholatEntity(
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

    test('two instances with identical 11 fields should be equal', () {
      expect(jadwal1, equals(jadwal2));
      expect(jadwal1 == jadwal2, isTrue);
    });

    test('two instances with different fajr should not be equal', () {
      const jadwalDifferent = JadwalSholatEntity(
        fajr: '05:00',
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
      expect(jadwal1 == jadwalDifferent, isFalse);
    });

    test('props contains all 11 fields', () {
      expect(
        jadwal1.props,
        [
          '04:30',
          '05:51',
          '11:53',
          '15:14',
          '17:55',
          '17:55',
          '19:08',
          '04:20',
          '23:53',
          '21:51',
          '01:54',
        ],
      );
    });
  });

  group('Failure', () {
    test('ConnectionFailure.props contains message', () {
      const failure = ConnectionFailure('Gagal terhubung ke server');
      expect(failure.props, ['Gagal terhubung ke server']);
      expect(failure.message, 'Gagal terhubung ke server');
    });

    test('ServerFailure.props contains message', () {
      const failure = ServerFailure('Internal server error');
      expect(failure.props, ['Internal server error']);
      expect(failure.message, 'Internal server error');
    });

    test('ResponseFailure.props contains message', () {
      const failure = ResponseFailure('Invalid response format');
      expect(failure.props, ['Invalid response format']);
      expect(failure.message, 'Invalid response format');
    });

    test('two ConnectionFailure with same message should be equal', () {
      const failure1 = ConnectionFailure('timeout');
      const failure2 = ConnectionFailure('timeout');
      expect(failure1, equals(failure2));
      expect(failure1 == failure2, isTrue);
    });

    test('two ConnectionFailure with different message should not be equal',
        () {
      const failure1 = ConnectionFailure('timeout');
      const failure2 = ConnectionFailure('no internet');
      expect(failure1 == failure2, isFalse);
    });

    test(
        'ConnectionFailure and ServerFailure with same message should not be equal (different types)',
        () {
      const connectionFailure = ConnectionFailure('error');
      const serverFailure = ServerFailure('error');
      expect(connectionFailure == serverFailure, isFalse);
    });
  });

  group('JadwalSholatDioEntity & JadwalSholatDataEntity', () {
    const timings = JadwalSholatEntity(
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

    test('JadwalSholatDataEntity equality and props', () {
      const data1 = JadwalSholatDataEntity(timings: timings);
      const data2 = JadwalSholatDataEntity(timings: timings);
      expect(data1, equals(data2));
      expect(data1.props, [timings]);
    });

    test('JadwalSholatDioEntity equality and props', () {
      const data = JadwalSholatDataEntity(timings: timings);
      const dio1 = JadwalSholatDioEntity(code: 200, status: 'OK', data: data);
      const dio2 = JadwalSholatDioEntity(code: 200, status: 'OK', data: data);
      expect(dio1, equals(dio2));
      expect(dio1.props, [200, 'OK', data]);
    });

    test('JadwalSholatDioEntity with different code should not be equal', () {
      const data = JadwalSholatDataEntity(timings: timings);
      const dio1 = JadwalSholatDioEntity(code: 200, status: 'OK', data: data);
      const dio2 = JadwalSholatDioEntity(code: 404, status: 'OK', data: data);
      expect(dio1, isNot(equals(dio2)));
    });
  });

  group('Property Tests', () {
    test('Property 1: Equatable Equality pada SurahEntity', () {
      // Feature: unit-testing, Property 1: SurahEntity equatable equality
      // **Validates: Requirements 2.1, 2.2**
      for (int i = 0; i < 100; i++) {
        final model = generateRandomSurahModel();
        final entity1 = model.toEntity();
        final entity2 = model.toEntity();

        // Same fields = equal
        expect(entity1, equals(entity2));

        // Change one field (nomor) → not equal
        final differentEntity = SurahEntity(
          nomor: entity1.nomor + 1,
          nama: entity1.nama,
          namaLatin: entity1.namaLatin,
          jumlahAyat: entity1.jumlahAyat,
          tempatTurun: entity1.tempatTurun,
          arti: entity1.arti,
          deskripsi: entity1.deskripsi,
          audioFull: entity1.audioFull,
        );
        expect(entity1, isNot(equals(differentEntity)));
      }
    });

    test(
        'Property 2: Equatable Equality pada DetailEntity dan AyatDetailEntity',
        () {
      // Feature: unit-testing, Property 2: DetailEntity dan AyatDetailEntity equatable equality
      // **Validates: Requirements 2.3, 2.4**
      for (int i = 0; i < 100; i++) {
        final model = generateRandomDetailModel();
        final entity1 = model.toEntity();
        final entity2 = model.toEntity();

        // Same fields including ayat list = equal
        expect(entity1, equals(entity2));

        // Verify ayat list elements are equal individually
        for (int j = 0; j < entity1.ayat.length; j++) {
          expect(entity1.ayat[j], equals(entity2.ayat[j]));
        }

        // Change nomor → not equal
        final differentEntity = DetailEntity(
          nomor: entity1.nomor + 1,
          nama: entity1.nama,
          namaLatin: entity1.namaLatin,
          jumlahAyat: entity1.jumlahAyat,
          tempatTurun: entity1.tempatTurun,
          arti: entity1.arti,
          deskripsi: entity1.deskripsi,
          audioFull: entity1.audioFull,
          ayat: entity1.ayat,
        );
        expect(entity1, isNot(equals(differentEntity)));
      }
    });

    test('Property 3: Equatable Equality pada JadwalSholatEntity', () {
      // Feature: unit-testing, Property 3: JadwalSholatEntity equatable equality (11 fields)
      // **Validates: Requirements 2.5**
      for (int i = 0; i < 100; i++) {
        final model = generateRandomJadwalSholatModel();
        final entity1 = model.toEntity();
        final entity2 = model.toEntity();

        // All 11 fields identical = equal
        expect(entity1, equals(entity2));

        // Change one field (fajr) → not equal
        final differentEntity = JadwalSholatEntity(
          fajr: '${entity1.fajr}x',
          sunrise: entity1.sunrise,
          dhuhr: entity1.dhuhr,
          asr: entity1.asr,
          sunset: entity1.sunset,
          maghrib: entity1.maghrib,
          isha: entity1.isha,
          imsak: entity1.imsak,
          midnight: entity1.midnight,
          firstthird: entity1.firstthird,
          lastthird: entity1.lastthird,
        );
        expect(entity1, isNot(equals(differentEntity)));
      }
    });
  });
}
