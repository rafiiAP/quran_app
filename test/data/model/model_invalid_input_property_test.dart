import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/detail_surah/data/models/detail_model.dart';
import 'package:quran_app/features/jadwal_sholat/data/models/jadwal_sholat_model.dart';
import 'package:quran_app/features/surah/data/models/surah_model.dart';

/// **Validates: Requirements 7.1, 7.2, 7.5**
///
/// Property 2: Invalid fromMap Input Produces FormatException
///
/// For each model, 100 random iterations choose a required field and either:
/// - Remove it (missing field)
/// - Set it to null
/// - Set it to a wrong type value
///
/// In all cases, fromMap must throw FormatException with the field name.
void main() {
  final random = Random(42);

  /// Generates a wrong-type value for a field that expects [expectedTypeName].
  /// We use string-based type names to avoid Dart generic type comparison issues.
  Object wrongTypeValue(String expectedTypeName, Random rng) {
    if (expectedTypeName == 'int') {
      return 'not_an_int_${rng.nextInt(999)}';
    } else if (expectedTypeName == 'String') {
      return rng.nextInt(99999);
    } else if (expectedTypeName == 'List') {
      return 'not_a_list';
    } else if (expectedTypeName == 'Map') {
      return 'not_a_map';
    }
    // Default: return an int for anything else
    return rng.nextInt(99999);
  }

  /// Creates a valid SurahModel map.
  Map<String, dynamic> generateValidSurahMap(Random rng) {
    return <String, dynamic>{
      'nomor': rng.nextInt(114) + 1,
      'nama': 'سورة_${rng.nextInt(100)}',
      'namaLatin': 'Surah_${rng.nextInt(100)}',
      'jumlahAyat': rng.nextInt(286) + 1,
      'tempatTurun': rng.nextBool() ? 'Mekah' : 'Madinah',
      'arti': 'arti_${rng.nextInt(100)}',
      'deskripsi': 'deskripsi_${rng.nextInt(100)}',
      'audioFull': <String, dynamic>{
        '01': 'https://example.com/audio_${rng.nextInt(100)}.mp3',
      },
    };
  }

  /// Creates a valid AyatDetailModel map.
  Map<String, dynamic> generateValidAyatMap(Random rng) {
    return <String, dynamic>{
      'nomorAyat': rng.nextInt(286) + 1,
      'teksArab': 'arab_${rng.nextInt(100)}',
      'teksLatin': 'latin_${rng.nextInt(100)}',
      'teksIndonesia': 'indonesia_${rng.nextInt(100)}',
      'audio': <String, dynamic>{
        '01': 'https://example.com/ayat_${rng.nextInt(100)}.mp3',
      },
    };
  }

  /// Creates a valid DetailModel map.
  Map<String, dynamic> generateValidDetailMap(Random rng) {
    return <String, dynamic>{
      'nomor': rng.nextInt(114) + 1,
      'nama': 'سورة_${rng.nextInt(100)}',
      'namaLatin': 'Detail_${rng.nextInt(100)}',
      'jumlahAyat': rng.nextInt(286) + 1,
      'tempatTurun': rng.nextBool() ? 'Mekah' : 'Madinah',
      'arti': 'arti_${rng.nextInt(100)}',
      'deskripsi': 'deskripsi_${rng.nextInt(100)}',
      'audioFull': <String, dynamic>{
        '01': 'https://example.com/audio_${rng.nextInt(100)}.mp3',
      },
      'ayat': <Map<String, dynamic>>[generateValidAyatMap(rng)],
    };
  }

  /// Creates a valid JadwalSholatModel map.
  Map<String, dynamic> generateValidJadwalSholatMap(Random rng) {
    String time() =>
        '${rng.nextInt(24).toString().padLeft(2, '0')}:${rng.nextInt(60).toString().padLeft(2, '0')}';
    return <String, dynamic>{
      'Fajr': time(),
      'Sunrise': time(),
      'Dhuhr': time(),
      'Asr': time(),
      'Sunset': time(),
      'Maghrib': time(),
      'Isha': time(),
      'Imsak': time(),
      'Midnight': time(),
      'Firstthird': time(),
      'Lastthird': time(),
    };
  }

  /// Creates a valid SurahaDioModel map.
  Map<String, dynamic> generateValidSurahaDioMap(Random rng) {
    return <String, dynamic>{
      'code': 200,
      'message': 'success',
      'data': <Map<String, dynamic>>[generateValidSurahMap(rng)],
    };
  }

  /// Creates a valid ResponseDetailModel map.
  Map<String, dynamic> generateValidResponseDetailMap(Random rng) {
    return <String, dynamic>{
      'code': 200,
      'message': 'success',
      'data': generateValidDetailMap(rng),
    };
  }

  /// Creates a valid JadwalSholatDioModel map.
  Map<String, dynamic> generateValidJadwalSholatDioMap(Random rng) {
    return <String, dynamic>{
      'code': 200,
      'status': 'OK',
      'data': <String, dynamic>{
        'timings': generateValidJadwalSholatMap(rng),
      },
    };
  }

  /// Creates a valid JadwalSholatDataModel map.
  Map<String, dynamic> generateValidJadwalSholatDataMap(Random rng) {
    return <String, dynamic>{
      'timings': generateValidJadwalSholatMap(rng),
    };
  }

  /// Field definitions: name → expected type name (as String)
  final surahFields = <String, String>{
    'nomor': 'int',
    'nama': 'String',
    'namaLatin': 'String',
    'jumlahAyat': 'int',
    'tempatTurun': 'String',
    'arti': 'String',
    'deskripsi': 'String',
    'audioFull': 'Map',
  };

  final ayatDetailFields = <String, String>{
    'nomorAyat': 'int',
    'teksArab': 'String',
    'teksLatin': 'String',
    'teksIndonesia': 'String',
    'audio': 'Map',
  };

  final detailFields = <String, String>{
    'nomor': 'int',
    'nama': 'String',
    'namaLatin': 'String',
    'jumlahAyat': 'int',
    'tempatTurun': 'String',
    'arti': 'String',
    'deskripsi': 'String',
    'audioFull': 'Map',
    'ayat': 'List',
  };

  final jadwalSholatFields = <String, String>{
    'Fajr': 'String',
    'Sunrise': 'String',
    'Dhuhr': 'String',
    'Asr': 'String',
    'Sunset': 'String',
    'Maghrib': 'String',
    'Isha': 'String',
    'Imsak': 'String',
    'Midnight': 'String',
    'Firstthird': 'String',
    'Lastthird': 'String',
  };

  final surahaDioFields = <String, String>{
    'code': 'int',
    'message': 'String',
    'data': 'List',
  };

  final responseDetailFields = <String, String>{
    'code': 'int',
    'message': 'String',
    'data': 'Map',
  };

  final jadwalSholatDioFields = <String, String>{
    'code': 'int',
    'status': 'String',
    'data': 'Map',
  };

  final jadwalSholatDataFields = <String, String>{
    'timings': 'Map',
  };

  group('Property 2: Invalid fromMap Input Produces FormatException', () {
    test(
        'SurahModel.fromMap throws FormatException for 100 random invalid inputs',
        () {
      // **Validates: Requirements 7.1, 7.2, 7.5**
      final fieldNames = surahFields.keys.toList();

      for (int i = 0; i < 100; i++) {
        final targetField = fieldNames[random.nextInt(fieldNames.length)];
        final validMap = generateValidSurahMap(random);
        final invalidationType = random.nextInt(3);

        switch (invalidationType) {
          case 0:
            validMap.remove(targetField);
          case 1:
            validMap[targetField] = null;
          case 2:
            validMap[targetField] =
                wrongTypeValue(surahFields[targetField]!, random);
        }

        expect(
          () => SurahModel.fromMap(validMap),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains(targetField),
            ),
          ),
          reason:
              'iteration $i: field=$targetField, invalidationType=$invalidationType',
        );
      }
    });

    test(
        'DetailModel.fromMap throws FormatException for 100 random invalid inputs',
        () {
      // **Validates: Requirements 7.1, 7.2, 7.5**
      final fieldNames = detailFields.keys.toList();

      for (int i = 0; i < 100; i++) {
        final targetField = fieldNames[random.nextInt(fieldNames.length)];
        final validMap = generateValidDetailMap(random);
        final invalidationType = random.nextInt(3);

        switch (invalidationType) {
          case 0:
            validMap.remove(targetField);
          case 1:
            validMap[targetField] = null;
          case 2:
            validMap[targetField] =
                wrongTypeValue(detailFields[targetField]!, random);
        }

        expect(
          () => DetailModel.fromMap(validMap),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains(targetField),
            ),
          ),
          reason:
              'iteration $i: field=$targetField, invalidationType=$invalidationType',
        );
      }
    });

    test(
        'AyatDetailModel.fromMap throws FormatException for 100 random invalid inputs',
        () {
      // **Validates: Requirements 7.1, 7.2, 7.5**
      final fieldNames = ayatDetailFields.keys.toList();

      for (int i = 0; i < 100; i++) {
        final targetField = fieldNames[random.nextInt(fieldNames.length)];
        final validMap = generateValidAyatMap(random);
        final invalidationType = random.nextInt(3);

        switch (invalidationType) {
          case 0:
            validMap.remove(targetField);
          case 1:
            validMap[targetField] = null;
          case 2:
            validMap[targetField] =
                wrongTypeValue(ayatDetailFields[targetField]!, random);
        }

        expect(
          () => AyatDetailModel.fromMap(validMap),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains(targetField),
            ),
          ),
          reason:
              'iteration $i: field=$targetField, invalidationType=$invalidationType',
        );
      }
    });

    test(
        'JadwalSholatModel.fromMap throws FormatException for 100 random invalid inputs',
        () {
      // **Validates: Requirements 7.1, 7.2, 7.5**
      final fieldNames = jadwalSholatFields.keys.toList();

      for (int i = 0; i < 100; i++) {
        final targetField = fieldNames[random.nextInt(fieldNames.length)];
        final validMap = generateValidJadwalSholatMap(random);
        final invalidationType = random.nextInt(3);

        switch (invalidationType) {
          case 0:
            validMap.remove(targetField);
          case 1:
            validMap[targetField] = null;
          case 2:
            validMap[targetField] =
                wrongTypeValue(jadwalSholatFields[targetField]!, random);
        }

        expect(
          () => JadwalSholatModel.fromMap(validMap),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains(targetField),
            ),
          ),
          reason:
              'iteration $i: field=$targetField, invalidationType=$invalidationType',
        );
      }
    });

    test(
        'SurahaDioModel.fromMap throws FormatException for 100 random invalid inputs',
        () {
      // **Validates: Requirements 7.1, 7.2, 7.5**
      final fieldNames = surahaDioFields.keys.toList();

      for (int i = 0; i < 100; i++) {
        final targetField = fieldNames[random.nextInt(fieldNames.length)];
        final validMap = generateValidSurahaDioMap(random);
        final invalidationType = random.nextInt(3);

        switch (invalidationType) {
          case 0:
            validMap.remove(targetField);
          case 1:
            validMap[targetField] = null;
          case 2:
            validMap[targetField] =
                wrongTypeValue(surahaDioFields[targetField]!, random);
        }

        expect(
          () => SurahaDioModel.fromMap(validMap),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains(targetField),
            ),
          ),
          reason:
              'iteration $i: field=$targetField, invalidationType=$invalidationType',
        );
      }
    });

    test(
        'ResponseDetailModel.fromMap throws FormatException for 100 random invalid inputs',
        () {
      // **Validates: Requirements 7.1, 7.2, 7.5**
      final fieldNames = responseDetailFields.keys.toList();

      for (int i = 0; i < 100; i++) {
        final targetField = fieldNames[random.nextInt(fieldNames.length)];
        final validMap = generateValidResponseDetailMap(random);
        final invalidationType = random.nextInt(3);

        switch (invalidationType) {
          case 0:
            validMap.remove(targetField);
          case 1:
            validMap[targetField] = null;
          case 2:
            validMap[targetField] =
                wrongTypeValue(responseDetailFields[targetField]!, random);
        }

        expect(
          () => ResponseDetailModel.fromMap(validMap),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains(targetField),
            ),
          ),
          reason:
              'iteration $i: field=$targetField, invalidationType=$invalidationType',
        );
      }
    });

    test(
        'JadwalSholatDioModel.fromMap throws FormatException for 100 random invalid inputs',
        () {
      // **Validates: Requirements 7.1, 7.2, 7.5**
      final fieldNames = jadwalSholatDioFields.keys.toList();

      for (int i = 0; i < 100; i++) {
        final targetField = fieldNames[random.nextInt(fieldNames.length)];
        final validMap = generateValidJadwalSholatDioMap(random);
        final invalidationType = random.nextInt(3);

        switch (invalidationType) {
          case 0:
            validMap.remove(targetField);
          case 1:
            validMap[targetField] = null;
          case 2:
            validMap[targetField] =
                wrongTypeValue(jadwalSholatDioFields[targetField]!, random);
        }

        expect(
          () => JadwalSholatDioModel.fromMap(validMap),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains(targetField),
            ),
          ),
          reason:
              'iteration $i: field=$targetField, invalidationType=$invalidationType',
        );
      }
    });

    test(
        'JadwalSholatDataModel.fromMap throws FormatException for 100 random invalid inputs',
        () {
      // **Validates: Requirements 7.1, 7.2, 7.5**
      final fieldNames = jadwalSholatDataFields.keys.toList();

      for (int i = 0; i < 100; i++) {
        final targetField = fieldNames[random.nextInt(fieldNames.length)];
        final validMap = generateValidJadwalSholatDataMap(random);
        final invalidationType = random.nextInt(3);

        switch (invalidationType) {
          case 0:
            validMap.remove(targetField);
          case 1:
            validMap[targetField] = null;
          case 2:
            validMap[targetField] =
                wrongTypeValue(jadwalSholatDataFields[targetField]!, random);
        }

        expect(
          () => JadwalSholatDataModel.fromMap(validMap),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains(targetField),
            ),
          ),
          reason:
              'iteration $i: field=$targetField, invalidationType=$invalidationType',
        );
      }
    });
  });
}
