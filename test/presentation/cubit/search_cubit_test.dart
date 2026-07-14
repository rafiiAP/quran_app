import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/surah/domain/entities/surah_entity.dart';
import 'package:quran_app/features/search/presentation/cubits/search_cubit/search_cubit.dart';

import '../../fixtures/surah_fixture.dart';
import '../../helpers/generators.dart';

void main() {
  group('SearchCubit — unit tests (blocTest)', () {
    blocTest<SearchCubit, SearchState>(
      'initial state is SearchState.initial()',
      build: () => SearchCubit(),
      verify: (cubit) => expect(cubit.state, const SearchState.initial()),
    );

    blocTest<SearchCubit, SearchState>(
      'onSearch with non-empty query filters by namaLatin (case-insensitive)',
      build: () => SearchCubit(),
      act: (cubit) => cubit.onSearch(
        surahList: [
          kSurahEntity, // namaLatin: 'Al-Fatihah'
          const SurahEntity(
            nomor: 2,
            nama: '',
            namaLatin: 'Al-Baqarah',
            jumlahAyat: 286,
            tempatTurun: 'Madinah',
            arti: 'Sapi Betina',
            deskripsi: '',
            audioFull: {},
          ),
        ],
        query: 'fatihah',
      ),
      expect: () => [
        const SearchState.results(results: [kSurahEntity]),
      ],
    );

    blocTest<SearchCubit, SearchState>(
      'onSearch with empty query emits empty results',
      build: () => SearchCubit(),
      act: (cubit) => cubit.onSearch(
        surahList: [kSurahEntity],
        query: '',
      ),
      expect: () => [
        const SearchState.results(results: []),
      ],
    );

    blocTest<SearchCubit, SearchState>(
      'onSearch is case-insensitive — uppercase query matches lowercase namaLatin',
      build: () => SearchCubit(),
      act: (cubit) => cubit.onSearch(
        surahList: [kSurahEntity], // namaLatin: 'Al-Fatihah'
        query: 'AL-FATIHAH',
      ),
      expect: () => [
        const SearchState.results(results: [kSurahEntity]),
      ],
    );

    blocTest<SearchCubit, SearchState>(
      'onSearch with query matching no item emits empty results',
      build: () => SearchCubit(),
      act: (cubit) => cubit.onSearch(
        surahList: [kSurahEntity],
        query: 'zzznomatch',
      ),
      expect: () => [
        const SearchState.results(results: []),
      ],
    );

    blocTest<SearchCubit, SearchState>(
      'clearSearch emits empty results',
      build: () => SearchCubit(),
      seed: () => const SearchState.results(results: [kSurahEntity]),
      act: (cubit) => cubit.clearSearch(),
      expect: () => [
        const SearchState.results(results: []),
      ],
    );
  });

  // ---------------------------------------------------------------------------
  // Property 13: SearchCubit Filter Correctness
  // Validates: Requirements 8.1, 8.2
  // ---------------------------------------------------------------------------
  group('Property 13: SearchCubit Filter Correctness', () {
    /// Helper: build a random non-empty alphabetic query of given length.
    String randomAlphaQuery(Random rng, {int maxLen = 6}) {
      const chars = 'abcdefghijklmnopqrstuvwxyz';
      final len = rng.nextInt(maxLen) + 1; // at least 1 char
      return List.generate(len, (_) => chars[rng.nextInt(chars.length)]).join();
    }

    // 13a — For random non-empty queries and random surah lists, ALL results
    //        must contain the query (case-insensitive) in namaLatin.
    test(
      'Property 13a: all results contain query (case-insensitive) in namaLatin',
      () {
        // **Validates: Requirements 8.1**
        final rng = Random(12345);

        for (int i = 0; i < 100; i++) {
          // Build a random list of 5–15 surah entities.
          final int listSize = rng.nextInt(11) + 5;
          final List<SurahEntity> surahList = List.generate(
            listSize,
            (_) => generateRandomSurahModel().toEntity(),
          );

          final String query = randomAlphaQuery(rng);

          final cubit = SearchCubit();
          cubit.onSearch(surahList: surahList, query: query);

          final state = cubit.state;
          final List<SurahEntity> results = state.maybeWhen(
            results: (r) => r,
            orElse: () => [],
          );

          // Every item in results must contain the query (case-insensitive).
          for (final SurahEntity entity in results) {
            expect(
              entity.namaLatin.toLowerCase().contains(query.toLowerCase()),
              isTrue,
              reason:
                  'Iteration $i: "${entity.namaLatin}" does not contain query "$query"',
            );
          }

          cubit.close();
        }
      },
    );

    // 13b — For any empty query, results are always empty.
    test(
      'Property 13b: empty query always produces empty results',
      () {
        // **Validates: Requirements 8.2**
        final rng = Random(99999);

        for (int i = 0; i < 100; i++) {
          final int listSize = rng.nextInt(20) + 1;
          final List<SurahEntity> surahList = List.generate(
            listSize,
            (_) => generateRandomSurahModel().toEntity(),
          );

          final cubit = SearchCubit();
          cubit.onSearch(surahList: surahList, query: '');

          final state = cubit.state;
          final List<SurahEntity> results = state.maybeWhen(
            results: (r) => r,
            orElse: () => [],
          );

          expect(
            results,
            isEmpty,
            reason: 'Iteration $i: empty query must produce empty results',
          );

          cubit.close();
        }
      },
    );
  });
}
