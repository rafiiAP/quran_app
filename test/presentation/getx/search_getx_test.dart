import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';
import 'package:quran_app/presentation/controller/serach/search_getx.dart';

void main() {
  late SearchGetx controller;
  late List<SurahEntity> testList;

  setUp(() {
    controller = SearchGetx();
    testList = const [
      SurahEntity(
        nomor: 1,
        nama: 'الفاتحة',
        namaLatin: 'Al-Fatihah',
        jumlahAyat: 7,
        tempatTurun: 'Mekah',
        arti: 'Pembuka',
        deskripsi: 'desc',
        audioFull: {},
      ),
      SurahEntity(
        nomor: 2,
        nama: 'البقرة',
        namaLatin: 'Al-Baqarah',
        jumlahAyat: 286,
        tempatTurun: 'Madinah',
        arti: 'Sapi',
        deskripsi: 'desc',
        audioFull: {},
      ),
      SurahEntity(
        nomor: 36,
        nama: 'يسٓ',
        namaLatin: 'Yasin',
        jumlahAyat: 83,
        tempatTurun: 'Mekah',
        arti: 'Yasin',
        deskripsi: 'desc',
        audioFull: {},
      ),
      SurahEntity(
        nomor: 55,
        nama: 'الرحمن',
        namaLatin: 'Ar-Rahman',
        jumlahAyat: 78,
        tempatTurun: 'Madinah',
        arti: 'Yang Maha Pengasih',
        deskripsi: 'desc',
        audioFull: {},
      ),
      SurahEntity(
        nomor: 112,
        nama: 'الإخلاص',
        namaLatin: 'Al-Ikhlas',
        jumlahAyat: 4,
        tempatTurun: 'Mekah',
        arti: 'Ikhlas',
        deskripsi: 'desc',
        audioFull: {},
      ),
    ];
  });

  group('onSearch()', () {
    test('filters by namaLatin containing "al" case-insensitive', () {
      // Validates: Requirements 14.1
      controller.onSearch(surahList: testList, value: 'al');

      expect(controller.vaSearch.value, isNotEmpty);
      for (final result in controller.vaSearch.value) {
        expect(
          result.namaLatin.toLowerCase().contains('al'),
          isTrue,
          reason: '${result.namaLatin} should contain "al" (case-insensitive)',
        );
      }
      // Expected matches: Al-Fatihah, Al-Baqarah, Al-Ikhlas
      expect(controller.vaSearch.value.length, 3);
    });

    test('"AL" produces same results as "al" (case-insensitive)', () {
      // Validates: Requirements 14.2
      controller.onSearch(surahList: testList, value: 'al');
      final lowerResults = List<SurahEntity>.from(controller.vaSearch.value);

      controller.onSearch(surahList: testList, value: 'AL');
      final upperResults = List<SurahEntity>.from(controller.vaSearch.value);

      expect(upperResults.length, lowerResults.length);
      expect(upperResults, lowerResults);
    });

    test('empty value produces empty vaSearch', () {
      // Validates: Requirements 14.3
      controller.onSearch(surahList: testList, value: '');

      expect(controller.vaSearch.value, isEmpty);
    });

    test('"xyznotfound" produces empty vaSearch', () {
      // Validates: Requirements 14.4
      controller.onSearch(surahList: testList, value: 'xyznotfound');

      expect(controller.vaSearch.value, isEmpty);
    });
  });

  group('Property Tests', () {
    test('Property 19: filter correctness — all results contain query', () {
      // Feature: unit-testing, Property 19: search filter correctness
      // **Validates: Requirements 14.1, 14.2, 14.3, 14.4, 14.5**
      final queries = [
        'al',
        'an',
        'ya',
        'Ar',
        'kh',
        'in',
        'at',
        'ah',
        'Ra',
        'ba'
      ];
      for (int i = 0; i < 100; i++) {
        final query = queries[i % queries.length];
        controller.onSearch(surahList: testList, value: query);
        for (final result in controller.vaSearch.value) {
          expect(
            result.namaLatin.toLowerCase().contains(query.toLowerCase()),
            isTrue,
            reason: '"${result.namaLatin}" should contain "$query"',
          );
        }
      }
    });

    test('Property 19: empty query produces empty results', () {
      // Feature: unit-testing, Property 19: empty query → empty results
      // **Validates: Requirements 14.1, 14.3**
      for (int i = 0; i < 100; i++) {
        controller.onSearch(surahList: testList, value: '');
        expect(controller.vaSearch.value, isEmpty);
      }
    });

    test('Property 20: case-insensitive metamorphic property', () {
      // Feature: unit-testing, Property 20: case-insensitive metamorphic
      // **Validates: Requirements 14.2, 14.5**
      final queries = [
        'al',
        'An',
        'YA',
        'mu',
        'RA',
        'kh',
        'at',
        'iN',
        'ar',
        'fa'
      ];
      for (final q in queries) {
        controller.onSearch(surahList: testList, value: q.toLowerCase());
        final lowerCount = controller.vaSearch.value.length;
        controller.onSearch(surahList: testList, value: q.toUpperCase());
        final upperCount = controller.vaSearch.value.length;
        expect(lowerCount, upperCount,
            reason: 'Query "$q": lower=$lowerCount, upper=$upperCount');
      }
    });
  });
}
