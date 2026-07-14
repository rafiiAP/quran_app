import 'package:quran_app/core/constants/config.dart';
import 'package:quran_app/core/di/injection.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/features/dashboard/presentation/cubits/home_cubit/home_cubit.dart';

import '../../mocks.dart';
import '../../fixtures/surah_fixture.dart';

void main() {
  late MockLocalStorageService mockStorageService;

  void stubStorageDefaults({
    String namaLatin = '',
    int nomorSurah = 0,
    int nomorAyat = 0,
  }) {
    when(
      () => mockStorageService.getString(
        key: 'cacheNamaLatin',
        defaultValue: any(named: 'defaultValue'),
      ),
    ).thenReturn(namaLatin);
    when(
      () => mockStorageService.getInt(
        key: 'cacheNomorSurah',
        defaultValue: any(named: 'defaultValue'),
      ),
    ).thenReturn(nomorSurah);
    when(
      () => mockStorageService.getInt(
        key: 'cacheNomorAyat',
        defaultValue: any(named: 'defaultValue'),
      ),
    ).thenReturn(nomorAyat);
  }

  setUp(() {
    locator.registerLazySingleton<AppConfig>(AppConfig.new);
    mockStorageService = MockLocalStorageService();
  });

  tearDown(() => locator.reset());

  // Requirements: 4.1 — HomeCubit reads last-read data from LocalStorageService on construction
  group('_loadLastRead (called on construction)', () {
    test(
        'reads namaLatin, nomorSurah, nomorAyat from LocalStorageService and emits loaded state',
        () {
      stubStorageDefaults(
        namaLatin: 'Al-Fatihah',
        nomorSurah: 1,
        nomorAyat: 3,
      );

      final cubit = HomeCubit(storageService: mockStorageService);

      expect(
        cubit.state,
        const HomeState.loaded(
          namaLatin: 'Al-Fatihah',
          nomorSurah: 1,
          nomorAyat: 3,
          surahList: [],
        ),
      );

      verify(
        () => mockStorageService.getString(
          key: 'cacheNamaLatin',
          defaultValue: any(named: 'defaultValue'),
        ),
      ).called(1);
      verify(
        () => mockStorageService.getInt(
          key: 'cacheNomorSurah',
          defaultValue: any(named: 'defaultValue'),
        ),
      ).called(1);
      verify(
        () => mockStorageService.getInt(
          key: 'cacheNomorAyat',
          defaultValue: any(named: 'defaultValue'),
        ),
      ).called(1);
    });

    test('emits loaded with empty defaults when storage returns default values',
        () {
      stubStorageDefaults();

      final cubit = HomeCubit(storageService: mockStorageService);

      expect(
        cubit.state,
        const HomeState.loaded(
          namaLatin: '',
          nomorSurah: 0,
          nomorAyat: 0,
          surahList: [],
        ),
      );
    });
  });

  // Requirements: 4.2 — setSurahList updates surahList while preserving other loaded fields
  group('setSurahList', () {
    blocTest<HomeCubit, HomeState>(
      'updates surahList in loaded state while preserving namaLatin, nomorSurah, nomorAyat',
      setUp: () => stubStorageDefaults(
        namaLatin: 'Al-Fatihah',
        nomorSurah: 1,
        nomorAyat: 3,
      ),
      build: () => HomeCubit(storageService: mockStorageService),
      act: (cubit) => cubit.setSurahList([kSurahEntity]),
      expect: () => [
        const HomeState.loaded(
          namaLatin: 'Al-Fatihah',
          nomorSurah: 1,
          nomorAyat: 3,
          surahList: [kSurahEntity],
        ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'setSurahList with empty list clears surahList in loaded state',
      setUp: () => stubStorageDefaults(namaLatin: 'Al-Baqarah', nomorSurah: 2),
      build: () => HomeCubit(storageService: mockStorageService),
      // First populate the list, then clear it — ensures a state change occurs
      act: (cubit) {
        cubit.setSurahList([kSurahEntity]);
        cubit.setSurahList([]);
      },
      expect: () => [
        const HomeState.loaded(
          namaLatin: 'Al-Baqarah',
          nomorSurah: 2,
          nomorAyat: 0,
          surahList: [kSurahEntity],
        ),
        const HomeState.loaded(
          namaLatin: 'Al-Baqarah',
          nomorSurah: 2,
          nomorAyat: 0,
          surahList: [],
        ),
      ],
    );
  });

  // Requirements: 4.3 — toLastRead with nomorSurah > 0 emits navigateToDetail then reloads loaded
  group('toLastRead — nomorSurah > 0', () {
    blocTest<HomeCubit, HomeState>(
      'emits [navigateToDetail, loaded] when nomorSurah > 0',
      setUp: () => stubStorageDefaults(
        namaLatin: 'Al-Fatihah',
        nomorSurah: 1,
        nomorAyat: 5,
      ),
      build: () => HomeCubit(storageService: mockStorageService),
      act: (cubit) => cubit.toLastRead(),
      expect: () => [
        const HomeState.navigateToDetail(nomorSurah: 1, indexTandai: 5),
        const HomeState.loaded(
          namaLatin: 'Al-Fatihah',
          nomorSurah: 1,
          nomorAyat: 5,
          surahList: [],
        ),
      ],
    );
  });

  // Requirements: 4.4 — toLastRead with nomorSurah == 0 emits showMessage then reloads loaded
  group('toLastRead — nomorSurah == 0', () {
    blocTest<HomeCubit, HomeState>(
      'emits [showMessage, loaded] when nomorSurah == 0',
      setUp: () => stubStorageDefaults(
        namaLatin: '',
        nomorSurah: 0,
        nomorAyat: 0,
      ),
      build: () => HomeCubit(storageService: mockStorageService),
      act: (cubit) => cubit.toLastRead(),
      expect: () => [
        const HomeState.showMessage('Belum ada bacaan terakhir'),
        const HomeState.loaded(
          namaLatin: '',
          nomorSurah: 0,
          nomorAyat: 0,
          surahList: [],
        ),
      ],
    );
  });
}
