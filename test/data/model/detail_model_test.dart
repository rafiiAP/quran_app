import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/detail_surah/data/models/detail_model.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';

import '../../helpers/generators.dart';

void main() {
  group('DetailModel', () {
    final tAyatMap1 = <String, dynamic>{
      'nomorAyat': 1,
      'teksArab': 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
      'teksLatin': 'Bismillāhir-raḥmānir-raḥīm(i).',
      'teksIndonesia': 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.',
      'audio': <String, dynamic>{'01': 'https://cdn.example.com/001001.mp3'},
    };

    final tAyatMap2 = <String, dynamic>{
      'nomorAyat': 2,
      'teksArab': 'اَلْحَمْدُ لِلّٰهِ رَبِّ الْعٰلَمِيْنَ',
      'teksLatin': 'Al-ḥamdu lillāhi rabbil-ʿālamīn(a).',
      'teksIndonesia': 'Segala puji bagi Allah, Tuhan seluruh alam.',
      'audio': <String, dynamic>{'01': 'https://cdn.example.com/001002.mp3'},
    };

    final tAyatMap3 = <String, dynamic>{
      'nomorAyat': 3,
      'teksArab': 'الرَّحْمٰنِ الرَّحِيْمِ',
      'teksLatin': 'Ar-raḥmānir-raḥīm(i).',
      'teksIndonesia': 'Yang Maha Pengasih, Maha Penyayang.',
      'audio': <String, dynamic>{'01': 'https://cdn.example.com/001003.mp3'},
    };

    final tDetailMap = <String, dynamic>{
      'nomor': 1,
      'nama': 'سُورَةُ الْفَاتِحَةِ',
      'namaLatin': 'Al-Fatihah',
      'jumlahAyat': 7,
      'tempatTurun': 'Mekah',
      'arti': 'Pembuka',
      'deskripsi': 'Surah pertama dalam Al-Quran',
      'audioFull': <String, dynamic>{
        '01': 'https://cdn.example.com/001.mp3',
        '02': 'https://cdn.example.com/001_2.mp3',
      },
      'ayat': [tAyatMap1, tAyatMap2, tAyatMap3],
    };

    test('fromMap() creates instance with correct ayat count', () {
      final result = DetailModel.fromMap(tDetailMap);

      expect(result.ayat, isA<List<AyatDetailModel>>());
      expect(result.ayat.length, 3);
      expect(result.nomor, 1);
      expect(result.namaLatin, 'Al-Fatihah');
      expect(result.jumlahAyat, 7);
    });

    test('toEntity() creates DetailEntity with same ayat count', () {
      final model = DetailModel.fromMap(tDetailMap);
      final entity = model.toEntity();

      expect(entity, isA<DetailEntity>());
      expect(entity.ayat, isA<List<AyatDetailEntity>>());
      expect(entity.ayat.length, model.ayat.length);
      expect(entity.nomor, model.nomor);
      expect(entity.namaLatin, model.namaLatin);
    });

    test('DetailModel.fromJson() parses from JSON string with ayat array', () {
      final jsonStr = json.encode(tDetailMap);
      final result = DetailModel.fromJson(jsonStr);

      expect(result.nomor, 1);
      expect(result.namaLatin, 'Al-Fatihah');
      expect(result.ayat.length, 3);
      expect(result.ayat.first.nomorAyat, 1);
    });

    test('DetailModel.toJson() returns valid JSON string', () {
      final model = DetailModel.fromMap(tDetailMap);
      final jsonStr = model.toJson();

      expect(jsonStr, isA<String>());
      final decoded = json.decode(jsonStr) as Map<String, dynamic>;
      expect(decoded['nomor'], 1);
      expect(decoded['namaLatin'], 'Al-Fatihah');
      expect(decoded['ayat'], isA<List<dynamic>>());
      expect((decoded['ayat'] as List<dynamic>).length, 3);
    });
  });

  group('AyatDetailModel', () {
    final tAyatMap = <String, dynamic>{
      'nomorAyat': 5,
      'teksArab': 'اِيَّاكَ نَعْبُدُ وَاِيَّاكَ نَسْتَعِيْنُ',
      'teksLatin': 'Iyyāka naʿbudu wa iyyāka nastaʿīn(u).',
      'teksIndonesia':
          'Hanya kepada Engkaulah kami menyembah dan hanya kepada Engkaulah kami mohon pertolongan.',
      'audio': <String, dynamic>{
        '01': 'https://cdn.example.com/001005.mp3',
        '02': 'https://cdn.example.com/001005_2.mp3',
      },
    };

    test('fromMap() creates instance with all fields correct', () {
      final result = AyatDetailModel.fromMap(tAyatMap);

      expect(result.nomorAyat, 5);
      expect(result.teksArab, 'اِيَّاكَ نَعْبُدُ وَاِيَّاكَ نَسْتَعِيْنُ');
      expect(result.teksLatin, 'Iyyāka naʿbudu wa iyyāka nastaʿīn(u).');
      expect(
        result.teksIndonesia,
        'Hanya kepada Engkaulah kami menyembah dan hanya kepada Engkaulah kami mohon pertolongan.',
      );
      expect(result.audio, {
        '01': 'https://cdn.example.com/001005.mp3',
        '02': 'https://cdn.example.com/001005_2.mp3',
      });
    });

    test('toEntity() creates AyatDetailEntity with same fields', () {
      final model = AyatDetailModel.fromMap(tAyatMap);
      final entity = model.toEntity();

      expect(entity, isA<AyatDetailEntity>());
      expect(entity.nomorAyat, model.nomorAyat);
      expect(entity.teksArab, model.teksArab);
      expect(entity.teksLatin, model.teksLatin);
      expect(entity.teksIndonesia, model.teksIndonesia);
      expect(entity.audio, model.audio);
    });

    test('AyatDetailModel.fromJson() parses from JSON string', () {
      final jsonStr = json.encode(tAyatMap);
      final result = AyatDetailModel.fromJson(jsonStr);

      expect(result.nomorAyat, 5);
      expect(result.teksArab, 'اِيَّاكَ نَعْبُدُ وَاِيَّاكَ نَسْتَعِيْنُ');
      expect(result.teksLatin, 'Iyyāka naʿbudu wa iyyāka nastaʿīn(u).');
      expect(result.audio.containsKey('01'), isTrue);
    });

    test('AyatDetailModel.toJson() returns valid JSON string', () {
      final model = AyatDetailModel.fromMap(tAyatMap);
      final jsonStr = model.toJson();

      expect(jsonStr, isA<String>());
      final decoded = json.decode(jsonStr) as Map<String, dynamic>;
      expect(decoded['nomorAyat'], 5);
      expect(decoded['teksArab'], 'اِيَّاكَ نَعْبُدُ وَاِيَّاكَ نَسْتَعِيْنُ');
      expect(decoded['audio'], isA<Map<String, dynamic>>());
    });
  });

  group('ResponseDetailModel', () {
    final tAyatMapR = <String, dynamic>{
      'nomorAyat': 1,
      'teksArab': 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
      'teksLatin': 'Bismillāhir-raḥmānir-raḥīm(i).',
      'teksIndonesia': 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.',
      'audio': <String, dynamic>{'01': 'https://cdn.example.com/001001.mp3'},
    };

    final tDetailMapR = <String, dynamic>{
      'nomor': 1,
      'nama': 'سُورَةُ الْفَاتِحَةِ',
      'namaLatin': 'Al-Fatihah',
      'jumlahAyat': 7,
      'tempatTurun': 'Mekah',
      'arti': 'Pembuka',
      'deskripsi': 'Surah pertama dalam Al-Quran',
      'audioFull': <String, dynamic>{'01': 'https://cdn.example.com/001.mp3'},
      'ayat': [tAyatMapR],
    };

    final tResponseMap = <String, dynamic>{
      'code': 200,
      'message': 'success',
      'data': tDetailMapR,
    };

    test('fromJson(str) parses from JSON string with nested detail data', () {
      final jsonStr = json.encode(tResponseMap);
      final result = ResponseDetailModel.fromJson(jsonStr);

      expect(result.code, 200);
      expect(result.message, 'success');
      expect(result.data, isA<DetailModel>());
      expect(result.data.nomor, 1);
      expect(result.data.namaLatin, 'Al-Fatihah');
      expect(result.data.ayat.length, 1);
    });

    test('fromMap(map) parses from Map directly', () {
      final result = ResponseDetailModel.fromMap(tResponseMap);

      expect(result.code, 200);
      expect(result.message, 'success');
      expect(result.data.nomor, 1);
    });

    test('toMap() returns map with keys code, message, data', () {
      final model = ResponseDetailModel.fromMap(tResponseMap);
      final result = model.toMap();

      expect(result.containsKey('code'), isTrue);
      expect(result.containsKey('message'), isTrue);
      expect(result.containsKey('data'), isTrue);
      expect(result['code'], 200);
      expect(result['message'], 'success');
    });

    test('toJson() returns valid JSON string', () {
      final model = ResponseDetailModel.fromMap(tResponseMap);
      final jsonStr = model.toJson();

      expect(jsonStr, isA<String>());
      final decoded = json.decode(jsonStr) as Map<String, dynamic>;
      expect(decoded['code'], 200);
      expect(decoded['message'], 'success');
      expect(decoded['data'], isA<Map<String, dynamic>>());
    });

    test('props equality — two identical instances must be equal', () {
      final model1 = ResponseDetailModel.fromMap(tResponseMap);
      final model2 = ResponseDetailModel.fromMap(tResponseMap);

      expect(model1, equals(model2));
      expect(model1.props, equals(model2.props));
    });
  });

  group('Property Tests', () {
    test('Property 7: fromMap(toMap()) round-trip for any DetailModel', () {
      // Feature: unit-testing, Property 7: DetailModel serialization round-trip
      // **Validates: Requirements 5.1, 5.5**
      for (int i = 0; i < 100; i++) {
        final original = generateRandomDetailModel();
        final roundTripped = DetailModel.fromMap(original.toMap());
        expect(roundTripped, equals(original));
        expect(roundTripped.ayat.length, original.ayat.length);
      }
    });

    test('Property 7: round-trip with empty ayat list', () {
      // Feature: unit-testing, Property 7: DetailModel serialization round-trip
      // **Validates: Requirements 5.1, 5.5**
      const emptyAyat = DetailModel(
        nomor: 1,
        nama: 'Test',
        namaLatin: 'Test',
        jumlahAyat: 0,
        tempatTurun: 'Mekah',
        arti: 'Test',
        deskripsi: 'Test',
        audioFull: {'01': 'https://cdn.example.com/1.mp3'},
        ayat: [],
      );
      final roundTripped = DetailModel.fromMap(emptyAyat.toMap());
      expect(roundTripped, equals(emptyAyat));
      expect(roundTripped.ayat, isEmpty);
    });
  });
}
