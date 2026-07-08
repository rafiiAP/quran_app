import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/data/model/jadwal_sholat_model.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';

import '../../fixtures/jadwal_sholat_fixture.dart';
import '../../helpers/generators.dart';

void main() {
  group('JadwalSholatModel', () {
    test('fromMap() creates correct instance with all 11 fields', () {
      final result = JadwalSholatModel.fromMap(kJadwalSholatMap);

      expect(result.fajr, '04:30');
      expect(result.sunrise, '05:51');
      expect(result.dhuhr, '11:53');
      expect(result.asr, '15:14');
      expect(result.sunset, '17:55');
      expect(result.maghrib, '17:55');
      expect(result.isha, '19:08');
      expect(result.imsak, '04:20');
      expect(result.midnight, '23:53');
      expect(result.firstthird, '21:51');
      expect(result.lastthird, '01:54');
      expect(result, equals(kJadwalSholatModel));
    });

    test('toEntity() creates JadwalSholatEntity with all 11 fields identical',
        () {
      final entity = kJadwalSholatModel.toEntity();

      expect(entity, isA<JadwalSholatEntity>());
      expect(entity.fajr, kJadwalSholatModel.fajr);
      expect(entity.sunrise, kJadwalSholatModel.sunrise);
      expect(entity.dhuhr, kJadwalSholatModel.dhuhr);
      expect(entity.asr, kJadwalSholatModel.asr);
      expect(entity.sunset, kJadwalSholatModel.sunset);
      expect(entity.maghrib, kJadwalSholatModel.maghrib);
      expect(entity.isha, kJadwalSholatModel.isha);
      expect(entity.imsak, kJadwalSholatModel.imsak);
      expect(entity.midnight, kJadwalSholatModel.midnight);
      expect(entity.firstthird, kJadwalSholatModel.firstthird);
      expect(entity.lastthird, kJadwalSholatModel.lastthird);
    });

    test('JadwalSholatModel.fromJson() parses from JSON string with 11 keys',
        () {
      final jsonStr = json.encode(kJadwalSholatMap);
      final result = JadwalSholatModel.fromJson(jsonStr);

      expect(result.fajr, '04:30');
      expect(result.sunrise, '05:51');
      expect(result.dhuhr, '11:53');
      expect(result.asr, '15:14');
      expect(result.sunset, '17:55');
      expect(result.maghrib, '17:55');
      expect(result.isha, '19:08');
      expect(result.imsak, '04:20');
      expect(result.midnight, '23:53');
      expect(result.firstthird, '21:51');
      expect(result.lastthird, '01:54');
      expect(result, equals(kJadwalSholatModel));
    });

    test('JadwalSholatModel.toJson() returns valid JSON string', () {
      final jsonStr = kJadwalSholatModel.toJson();

      expect(jsonStr, isA<String>());
      final decoded = json.decode(jsonStr) as Map<String, dynamic>;
      expect(decoded['Fajr'], '04:30');
      expect(decoded['Sunrise'], '05:51');
      expect(decoded.length, 11);
    });
  });

  group('JadwalSholatDioModel', () {
    test('fromJson() parses nested data.timings structure', () {
      final Map<String, dynamic> jsonMap = {
        'code': 200,
        'status': 'OK',
        'data': {
          'timings': {
            'Fajr': '04:30',
            'Sunrise': '05:51',
            'Dhuhr': '11:53',
            'Asr': '15:14',
            'Sunset': '17:55',
            'Maghrib': '17:55',
            'Isha': '19:08',
            'Imsak': '04:20',
            'Midnight': '23:53',
            'Firstthird': '21:51',
            'Lastthird': '01:54',
          },
        },
      };
      final jsonStr = json.encode(jsonMap);

      final result = JadwalSholatDioModel.fromJson(jsonStr);

      expect(result.code, 200);
      expect(result.status, 'OK');
      expect(result.data.timings, equals(kJadwalSholatModel));
      expect(result.data.timings.fajr, '04:30');
      expect(result.data.timings.sunrise, '05:51');
      expect(result.data.timings.dhuhr, '11:53');
      expect(result.data.timings.asr, '15:14');
      expect(result.data.timings.sunset, '17:55');
      expect(result.data.timings.maghrib, '17:55');
      expect(result.data.timings.isha, '19:08');
      expect(result.data.timings.imsak, '04:20');
      expect(result.data.timings.midnight, '23:53');
      expect(result.data.timings.firstthird, '21:51');
      expect(result.data.timings.lastthird, '01:54');
    });

    test('toMap() returns map with keys code, status, data', () {
      const dataModel = JadwalSholatDataModel(timings: kJadwalSholatModel);
      const dioModel = JadwalSholatDioModel(
        code: 200,
        status: 'OK',
        data: dataModel,
      );

      final result = dioModel.toMap();

      expect(result.containsKey('code'), isTrue);
      expect(result.containsKey('status'), isTrue);
      expect(result.containsKey('data'), isTrue);
      expect(result['code'], 200);
      expect(result['status'], 'OK');
    });

    test('toJson() returns valid JSON string', () {
      const dataModel = JadwalSholatDataModel(timings: kJadwalSholatModel);
      const dioModel = JadwalSholatDioModel(
        code: 200,
        status: 'OK',
        data: dataModel,
      );

      final jsonStr = dioModel.toJson();

      expect(jsonStr, isA<String>());
      final decoded = json.decode(jsonStr) as Map<String, dynamic>;
      expect(decoded['code'], 200);
      expect(decoded['status'], 'OK');
      expect(decoded['data'], isA<Map>());
    });

    test('props equality — two identical instances must be equal', () {
      const dataModel = JadwalSholatDataModel(timings: kJadwalSholatModel);
      const model1 =
          JadwalSholatDioModel(code: 200, status: 'OK', data: dataModel);
      const model2 =
          JadwalSholatDioModel(code: 200, status: 'OK', data: dataModel);

      expect(model1, equals(model2));
      expect(model1.props, equals(model2.props));
    });
  });

  group('JadwalSholatDataModel', () {
    final tTimingsMap = <String, dynamic>{
      'Fajr': '04:30',
      'Sunrise': '05:51',
      'Dhuhr': '11:53',
      'Asr': '15:14',
      'Sunset': '17:55',
      'Maghrib': '17:55',
      'Isha': '19:08',
      'Imsak': '04:20',
      'Midnight': '23:53',
      'Firstthird': '21:51',
      'Lastthird': '01:54',
    };

    final tDataMap = <String, dynamic>{
      'timings': tTimingsMap,
    };

    test('fromJson(str) parses from JSON string with nested timings', () {
      final jsonStr = json.encode(tDataMap);
      final result = JadwalSholatDataModel.fromJson(jsonStr);

      expect(result.timings, isA<JadwalSholatModel>());
      expect(result.timings.fajr, '04:30');
      expect(result.timings.isha, '19:08');
      expect(result.timings, equals(kJadwalSholatModel));
    });

    test('fromMap(map) parses from Map with timings key', () {
      final result = JadwalSholatDataModel.fromMap(tDataMap);

      expect(result.timings, isA<JadwalSholatModel>());
      expect(result.timings, equals(kJadwalSholatModel));
    });

    test('toMap() returns map with key timings', () {
      const dataModel = JadwalSholatDataModel(timings: kJadwalSholatModel);
      final result = dataModel.toMap();

      expect(result.containsKey('timings'), isTrue);
      expect(result['timings'], isA<Map>());
    });

    test('toJson() returns valid JSON string', () {
      const dataModel = JadwalSholatDataModel(timings: kJadwalSholatModel);
      final jsonStr = dataModel.toJson();

      expect(jsonStr, isA<String>());
      final decoded = json.decode(jsonStr) as Map<String, dynamic>;
      expect(decoded.containsKey('timings'), isTrue);
      expect(decoded['timings'], isA<Map>());
    });

    test('props equality — two identical instances must be equal', () {
      const model1 = JadwalSholatDataModel(timings: kJadwalSholatModel);
      const model2 = JadwalSholatDataModel(timings: kJadwalSholatModel);

      expect(model1, equals(model2));
      expect(model1.props, equals(model2.props));
    });
  });

  group('Property Tests', () {
    test('Property 8: fromMap(toMap()) round-trip for any JadwalSholatModel',
        () {
      // Feature: unit-testing, Property 8: JadwalSholatModel serialization round-trip
      // **Validates: Requirements 6.1, 6.4**
      for (int i = 0; i < 100; i++) {
        final original = generateRandomJadwalSholatModel();
        final roundTripped = JadwalSholatModel.fromMap(original.toMap());
        expect(roundTripped, equals(original));
      }
    });
  });
}
