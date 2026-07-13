import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/data/model/surah_model.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';

import '../../fixtures/surah_fixture.dart';
import '../../helpers/generators.dart';

void main() {
  group('SurahModel', () {
    test('fromMap() creates correct instance from valid Map', () {
      // Validates: Requirements 4.1
      final result = SurahModel.fromMap(kSurahMap);

      expect(result.nomor, kSurahMap['nomor']);
      expect(result.nama, kSurahMap['nama']);
      expect(result.namaLatin, kSurahMap['namaLatin']);
      expect(result.jumlahAyat, kSurahMap['jumlahAyat']);
      expect(result.tempatTurun, kSurahMap['tempatTurun']);
      expect(result.arti, kSurahMap['arti']);
      expect(result.deskripsi, kSurahMap['deskripsi']);
      expect(result.audioFull, kSurahMap['audioFull']);
      expect(result, equals(kSurahModel));
    });

    test('toMap() returns Map with all 8 keys', () {
      // Validates: Requirements 4.2
      final result = kSurahModel.toMap();

      expect(result.containsKey('nomor'), isTrue);
      expect(result.containsKey('nama'), isTrue);
      expect(result.containsKey('namaLatin'), isTrue);
      expect(result.containsKey('jumlahAyat'), isTrue);
      expect(result.containsKey('tempatTurun'), isTrue);
      expect(result.containsKey('arti'), isTrue);
      expect(result.containsKey('deskripsi'), isTrue);
      expect(result.containsKey('audioFull'), isTrue);
      expect(result.length, 8);
    });

    test('toEntity() creates SurahEntity with identical fields', () {
      // Validates: Requirements 4.3
      final entity = kSurahModel.toEntity();

      expect(entity, isA<SurahEntity>());
      expect(entity.nomor, kSurahModel.nomor);
      expect(entity.nama, kSurahModel.nama);
      expect(entity.namaLatin, kSurahModel.namaLatin);
      expect(entity.jumlahAyat, kSurahModel.jumlahAyat);
      expect(entity.tempatTurun, kSurahModel.tempatTurun);
      expect(entity.arti, kSurahModel.arti);
      expect(entity.deskripsi, kSurahModel.deskripsi);
      expect(entity.audioFull, kSurahModel.audioFull);
      expect(entity, equals(kSurahEntity));
    });

    test('fromMap() throws TypeError when nomor is not int', () {
      // Validates: Requirements 4.6
      final badMap = <String, dynamic>{
        'nomor': 'bukan_int',
        'nama': 'سُورَةُ الْفَاتِحَةِ',
        'namaLatin': 'Al-Fatihah',
        'jumlahAyat': 7,
        'tempatTurun': 'Mekah',
        'arti': 'Pembuka',
        'deskripsi': 'Surah pembuka Al-Quran',
        'audioFull': <String, String>{
          '01': 'https://cdn.islamic.network/quran/audio/1/ar.alafasy/1.mp3',
        },
      };

      expect(() => SurahModel.fromMap(badMap), throwsA(isA<TypeError>()));
    });
  });

  group('SurahaDioModel', () {
    test('fromJson() parses API JSON wrapper correctly', () {
      // Validates: Requirements 4.5
      final jsonMap = {
        'code': 200,
        'message': 'success',
        'data': [
          {
            'nomor': 1,
            'nama': 'سُورَةُ الْفَاتِحَةِ',
            'namaLatin': 'Al-Fatihah',
            'jumlahAyat': 7,
            'tempatTurun': 'Mekah',
            'arti': 'Pembuka',
            'deskripsi': 'Surah pembuka Al-Quran',
            'audioFull': {
              '01':
                  'https://cdn.islamic.network/quran/audio/1/ar.alafasy/1.mp3',
            },
          },
          {
            'nomor': 2,
            'nama': 'سُورَةُ البَقَرَةِ',
            'namaLatin': 'Al-Baqarah',
            'jumlahAyat': 286,
            'tempatTurun': 'Madinah',
            'arti': 'Sapi',
            'deskripsi': 'Surah terpanjang',
            'audioFull': {
              '01':
                  'https://cdn.islamic.network/quran/audio/2/ar.alafasy/1.mp3',
            },
          },
        ],
      };
      final jsonStr = json.encode(jsonMap);

      final result = SurahaDioModel.fromJson(jsonStr);

      expect(result.code, 200);
      expect(result.message, 'success');
      expect(result.data, isA<List<SurahModel>>());
      expect(result.data, isNotEmpty);
      expect(result.data.length, 2);
      expect(result.data.first.nomor, 1);
      expect(result.data.first.namaLatin, 'Al-Fatihah');
      expect(result.data.last.nomor, 2);
      expect(result.data.last.namaLatin, 'Al-Baqarah');
    });
  });

  group('Property Tests', () {
    test('Property 5: fromMap(toMap()) round-trip for any SurahModel', () {
      // Feature: unit-testing, Property 5: SurahModel serialization round-trip
      // **Validates: Requirements 4.1, 4.4**
      for (int i = 0; i < 100; i++) {
        final original = generateRandomSurahModel();
        final roundTripped = SurahModel.fromMap(original.toMap());
        expect(roundTripped, equals(original));
      }
    });

    test('Property 6: toEntity() preserves all 8 fields', () {
      // Feature: unit-testing, Property 6: SurahModel ke SurahEntity konversi
      // **Validates: Requirements 4.3**
      for (int i = 0; i < 100; i++) {
        final model = generateRandomSurahModel();
        final entity = model.toEntity();
        expect(entity.nomor, model.nomor);
        expect(entity.nama, model.nama);
        expect(entity.namaLatin, model.namaLatin);
        expect(entity.jumlahAyat, model.jumlahAyat);
        expect(entity.tempatTurun, model.tempatTurun);
        expect(entity.arti, model.arti);
        expect(entity.deskripsi, model.deskripsi);
        expect(entity.audioFull, model.audioFull);
      }
    });
  });

  group('SurahModel additional coverage', () {
    test('SurahModel.fromJson() produces same result as fromMap()', () {
      final jsonStr = json.encode(kSurahMap);
      final fromJsonResult = SurahModel.fromJson(jsonStr);
      final fromMapResult = SurahModel.fromMap(kSurahMap);

      expect(fromJsonResult, equals(fromMapResult));
      expect(fromJsonResult.nomor, kSurahMap['nomor']);
      expect(fromJsonResult.namaLatin, kSurahMap['namaLatin']);
    });

    test('SurahModel.toJson() returns valid JSON string that can be re-parsed',
        () {
      final jsonStr = kSurahModel.toJson();

      expect(jsonStr, isA<String>());
      final decoded = json.decode(jsonStr) as Map<String, dynamic>;
      final reparsed = SurahModel.fromMap(decoded);
      expect(reparsed, equals(kSurahModel));
    });

    test('SurahaDioModel.toMap() returns map with keys code, message, data',
        () {
      const dioModel = SurahaDioModel(
        code: 200,
        message: 'success',
        data: [kSurahModel],
      );

      final result = dioModel.toMap();

      expect(result.containsKey('code'), isTrue);
      expect(result.containsKey('message'), isTrue);
      expect(result.containsKey('data'), isTrue);
      expect(result['code'], 200);
      expect(result['message'], 'success');
    });

    test(
        'SurahaDioModel.toJson() returns valid JSON string, can be decoded back',
        () {
      const dioModel = SurahaDioModel(
        code: 200,
        message: 'success',
        data: [kSurahModel],
      );

      final jsonStr = dioModel.toJson();

      expect(jsonStr, isA<String>());
      final decoded = json.decode(jsonStr) as Map<String, dynamic>;
      expect(decoded['code'], 200);
      expect(decoded['message'], 'success');
      expect(decoded['data'], isA<List<dynamic>>());
    });

    test(
        'SurahaDioModel equality (props) — two identical instances must be equal',
        () {
      const model1 = SurahaDioModel(
        code: 200,
        message: 'success',
        data: [kSurahModel],
      );
      const model2 = SurahaDioModel(
        code: 200,
        message: 'success',
        data: [kSurahModel],
      );

      expect(model1, equals(model2));
      expect(model1.props, equals(model2.props));
    });
  });
}
