import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/presentation/controller/dashboard/home_cubit/home_cubit.dart';

import '../../mocks.dart';
import '../../helpers/generators.dart';

/// Seeded RNG for reproducible property tests
final Random _rng = Random(99);

String _randomString([int length = 10]) {
  const chars = 'abcdefghijklmnopqrstuvwxyz';
  return List.generate(length, (_) => chars[_rng.nextInt(chars.length)]).join();
}

int _randomPositiveNomor() => 1 + _rng.nextInt(114);

int _randomNomorAyat() => 1 + _rng.nextInt(286);

void main() {
  late MockLocalStorageService mockStorage;

  setUp(() {
    mockStorage = MockLocalStorageService();
  });

  // ---------------------------------------------------------------------------
  // Property 4: HomeCubit Last-Read State Integrity
  // **Validates: Requirements 4.1, 4.2**
  // For 100 random (namaLatin, nomorSurah, nomorAyat) combinations, mock
  // storage to return those values, construct HomeCubit, verify the loaded
  // state contains values identical to what was mocked.
  // ---------------------------------------------------------------------------
  group('Property Tests', () {
    test(
      'Property 4: HomeCubit Last-Read State Integrity — '
      'loaded state must mirror storage values exactly',
      () {
        for (int i = 0; i < 100; i++) {
          final namaLatin = _randomString(8 + _rng.nextInt(10));
          final nomorSurah = _randomPositiveNomor();
          final nomorAyat = _randomNomorAyat();

          when(() => mockStorage.getString(
                key: 'cacheNamaLatin',
                defaultValue: any(named: 'defaultValue'),
              )).thenReturn(namaLatin);
          when(() => mockStorage.getInt(
                key: 'cacheNomorSurah',
                defaultValue: any(named: 'defaultValue'),
              )).thenReturn(nomorSurah);
          when(() => mockStorage.getInt(
                key: 'cacheNomorAyat',
                defaultValue: any(named: 'defaultValue'),
              )).thenReturn(nomorAyat);

          final cubit = HomeCubit(storageService: mockStorage);

          String? gotNamaLatin;
          int? gotNomorSurah;
          int? gotNomorAyat;

          cubit.state.maybeWhen(
            loaded: (nl, ns, na, _) {
              gotNamaLatin = nl;
              gotNomorSurah = ns;
              gotNomorAyat = na;
            },
            orElse: () {},
          );

          expect(gotNamaLatin, equals(namaLatin),
              reason: 'iteration $i: namaLatin mismatch');
          expect(gotNomorSurah, equals(nomorSurah),
              reason: 'iteration $i: nomorSurah mismatch');
          expect(gotNomorAyat, equals(nomorAyat),
              reason: 'iteration $i: nomorAyat mismatch');

          cubit.close();
        }
      },
    );

    // -------------------------------------------------------------------------
    // Property 5: HomeCubit Surah List Assignment
    // **Validates: Requirements 4.2, 4.3**
    // For 100 iterations, call setSurahList(list) on a loaded cubit and verify
    // that the resulting state.surahList is identical to the list passed in.
    // -------------------------------------------------------------------------
    test(
      'Property 5: HomeCubit Surah List Assignment — '
      'setSurahList must produce state with identical surahList',
      () {
        // Provide stable storage stubs once for all iterations
        when(() => mockStorage.getString(
              key: any(named: 'key'),
              defaultValue: any(named: 'defaultValue'),
            )).thenReturn('');
        when(() => mockStorage.getInt(
              key: any(named: 'key'),
              defaultValue: any(named: 'defaultValue'),
            )).thenReturn(0);

        for (int i = 0; i < 100; i++) {
          final listSize = _rng.nextInt(10); // 0..9 surah items
          final surahList = List.generate(
            listSize,
            (_) => generateRandomSurahModel().toEntity(),
          );

          final cubit = HomeCubit(storageService: mockStorage);
          cubit.setSurahList(surahList);

          List<dynamic>? gotSurahList;
          cubit.state.maybeWhen(
            loaded: (_, __, ___, sl) {
              gotSurahList = sl;
            },
            orElse: () {},
          );

          expect(gotSurahList, equals(surahList),
              reason:
                  'iteration $i: surahList mismatch (size ${surahList.length})');

          cubit.close();
        }
      },
    );

    // -------------------------------------------------------------------------
    // Property 6: HomeCubit Last-Read Navigation Logic
    // **Validates: Requirements 4.3, 4.4**
    // For 100 iterations:
    //   - nomorSurah > 0  → toLastRead() emits navigateToDetail
    //   - nomorSurah == 0 → toLastRead() emits showMessage
    // Verified by listening to the stream after toLastRead() is called.
    // -------------------------------------------------------------------------
    test(
      'Property 6: HomeCubit Last-Read Navigation Logic — '
      'nomorSurah > 0 → navigateToDetail, nomorSurah == 0 → showMessage',
      () async {
        for (int i = 0; i < 100; i++) {
          final usePositive = i.isEven;
          final nomorSurah = usePositive ? _randomPositiveNomor() : 0;
          final nomorAyat = _randomNomorAyat();
          final namaLatin = _randomString(6);

          // Storage returns values for _loadLastRead() calls (constructor + after toLastRead)
          when(() => mockStorage.getString(
                key: 'cacheNamaLatin',
                defaultValue: any(named: 'defaultValue'),
              )).thenReturn(namaLatin);
          when(() => mockStorage.getInt(
                key: 'cacheNomorSurah',
                defaultValue: any(named: 'defaultValue'),
              )).thenReturn(nomorSurah);
          when(() => mockStorage.getInt(
                key: 'cacheNomorAyat',
                defaultValue: any(named: 'defaultValue'),
              )).thenReturn(nomorAyat);

          final cubit = HomeCubit(storageService: mockStorage);

          // Collect emitted states after toLastRead()
          final emitted = <HomeState>[];
          final sub = cubit.stream.listen(emitted.add);

          cubit.toLastRead();

          // Allow microtask queue to flush
          await Future.delayed(Duration.zero);
          await sub.cancel();

          if (usePositive) {
            // First emitted state must be navigateToDetail
            expect(emitted.isNotEmpty, isTrue,
                reason:
                    'iteration $i (nomorSurah=$nomorSurah): no states emitted');
            final firstState = emitted.first;
            bool isNavigate = false;
            firstState.maybeWhen(
              navigateToDetail: (_, __) => isNavigate = true,
              orElse: () {},
            );
            expect(isNavigate, isTrue,
                reason:
                    'iteration $i (nomorSurah=$nomorSurah): expected navigateToDetail, got $firstState');
          } else {
            // First emitted state must be showMessage
            expect(emitted.isNotEmpty, isTrue,
                reason: 'iteration $i (nomorSurah=0): no states emitted');
            final firstState = emitted.first;
            bool isShowMessage = false;
            firstState.maybeWhen(
              showMessage: (_) => isShowMessage = true,
              orElse: () {},
            );
            expect(isShowMessage, isTrue,
                reason:
                    'iteration $i (nomorSurah=0): expected showMessage, got $firstState');
          }

          await cubit.close();
        }
      },
    );
  });
}
