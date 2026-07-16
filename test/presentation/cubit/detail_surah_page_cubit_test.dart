import 'package:quran_app/core/constants/config.dart';
import 'package:quran_app/core/di/injection.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';
import 'package:quran_app/features/detail_surah/presentation/cubits/detail_surah_page_cubit/detail_surah_page_cubit.dart';

import '../../helpers/generators.dart';
import '../../mocks.dart';

void main() {
  late MockLocalStorageService mockStorageService;
  late MockSaveBookmarkUseCase mockSaveBookmarkUseCase;

  setUp(() {
    locator.registerLazySingleton<AppConfig>(AppConfig.new);
    mockStorageService = MockLocalStorageService();
    mockSaveBookmarkUseCase = MockSaveBookmarkUseCase();

    // Default stubs so constructor doesn't throw
    when(
      () => mockStorageService.setString(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => mockStorageService.setInt(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});
  });

  tearDown(() => locator.reset());

  // ---------------------------------------------------------------------------
  // Unit tests (task 8.3)
  // ---------------------------------------------------------------------------

  // Requirements: 6.4 — markAsLastRead writes correct keys and emits actionCompleted then idle
  group('markAsLastRead', () {
    blocTest<DetailSurahPageCubit, DetailSurahPageState>(
      'emits [actionCompleted, idle] and writes to storage',
      build: () => DetailSurahPageCubit(
        storageService: mockStorageService,
        saveBookmarkUseCase: mockSaveBookmarkUseCase,
      ),
      act: (cubit) => cubit.markAsLastRead(
        namaLatin: 'Al-Fatihah',
        nomorSurah: 1,
        nomorAyat: 3,
      ),
      expect: () => [
        const DetailSurahPageState.actionCompleted(
          message: 'Berhasil ditandai sebagai bacaan terakhir',
        ),
        const DetailSurahPageState.idle(),
      ],
      verify: (_) {
        verify(
          () => mockStorageService.setString(
            key: 'cacheNamaLatin',
            value: 'Al-Fatihah',
          ),
        ).called(1);
        verify(
          () => mockStorageService.setInt(
            key: 'cacheNomorSurah',
            value: 1,
          ),
        ).called(1);
        verify(
          () => mockStorageService.setInt(
            key: 'cacheNomorAyat',
            value: 3,
          ),
        ).called(1);
      },
    );
  });

  // Requirements: 6.7 — saveBookmark emits actionCompleted with correct message
  group('saveBookmark', () {
    const kAyat = AyatDetailEntity(
      nomorAyat: 1,
      teksArab: 'بِسْمِ اللَّهِ',
      teksLatin: 'bismillah',
      teksIndonesia: 'Dengan nama Allah',
      audio: {},
    );
    const kDetail = DetailEntity(
      nomor: 1,
      nama: 'الفاتحة',
      namaLatin: 'Al-Fatihah',
      jumlahAyat: 7,
      tempatTurun: 'Mekah',
      arti: 'Pembukaan',
      deskripsi: '',
      audioFull: {},
      ayat: [],
    );

    blocTest<DetailSurahPageCubit, DetailSurahPageState>(
      'emits actionCompleted("Berhasil disimpan ke bookmark") when insertOrUpdateBookmark returns true',
      setUp: () {
        when(
          () => mockSaveBookmarkUseCase(ayat: kAyat, detail: kDetail),
        ).thenAnswer((_) async => const Right(true));
      },
      build: () => DetailSurahPageCubit(
        storageService: mockStorageService,
        saveBookmarkUseCase: mockSaveBookmarkUseCase,
      ),
      act: (cubit) => cubit.saveBookmark(ayat: kAyat, detail: kDetail),
      expect: () => [
        const DetailSurahPageState.actionCompleted(
          message: 'Berhasil disimpan ke bookmark',
        ),
        const DetailSurahPageState.idle(),
      ],
    );

    blocTest<DetailSurahPageCubit, DetailSurahPageState>(
      'emits actionCompleted("Data sudah ada") when insertOrUpdateBookmark returns false',
      setUp: () {
        when(
          () => mockSaveBookmarkUseCase(ayat: kAyat, detail: kDetail),
        ).thenAnswer((_) async => const Right(false));
      },
      build: () => DetailSurahPageCubit(
        storageService: mockStorageService,
        saveBookmarkUseCase: mockSaveBookmarkUseCase,
      ),
      act: (cubit) => cubit.saveBookmark(ayat: kAyat, detail: kDetail),
      expect: () => [
        const DetailSurahPageState.actionCompleted(message: 'Data sudah ada'),
        const DetailSurahPageState.idle(),
      ],
    );
  });

  // Requirements: 6.9 — formatCopyText produces correct format
  group('formatCopyText', () {
    test('returns correct format string for specific ayat and detail', () {
      final cubit = DetailSurahPageCubit(
        storageService: mockStorageService,
        saveBookmarkUseCase: mockSaveBookmarkUseCase,
      );

      const ayat = AyatDetailEntity(
        nomorAyat: 1,
        teksArab: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        teksLatin: 'bismillahirrahmanirrahim',
        teksIndonesia: 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang',
        audio: {},
      );
      const detail = DetailEntity(
        nomor: 1,
        nama: 'الفاتحة',
        namaLatin: 'Al-Fatihah',
        jumlahAyat: 7,
        tempatTurun: 'Mekah',
        arti: 'Pembukaan',
        deskripsi: '',
        audioFull: {},
        ayat: [],
      );

      final result = cubit.formatCopyText(ayat: ayat, detail: detail);

      expect(
        result,
        'Al-Fatihah, ayat ke-1\n\n'
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n\n'
        'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang (1)',
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Property tests (task 8.4)
  // ---------------------------------------------------------------------------

  // **Property 9: DetailSurahPageCubit Copy Format Completeness**
  // For any AyatDetailEntity and DetailEntity, formatCopyText() must contain
  // namaLatin, nomorAyat.toString(), teksArab, and teksIndonesia.
  // **Validates: Requirements 6.2**
  test(
    'Property 9: formatCopyText output contains namaLatin, nomorAyat, teksArab, teksIndonesia',
    () {
      final cubit = DetailSurahPageCubit(
        storageService: mockStorageService,
        saveBookmarkUseCase: mockSaveBookmarkUseCase,
      );

      for (int i = 0; i < 100; i++) {
        final detailModel = generateRandomDetailModel();
        final detail = detailModel.toEntity();

        // Pick one ayat from the generated detail (or first if available)
        final AyatDetailEntity ayat = detail.ayat.isNotEmpty
            ? detail.ayat.first
            : AyatDetailEntity(
                nomorAyat: i + 1,
                teksArab: 'arab_$i',
                teksLatin: 'latin_$i',
                teksIndonesia: 'indonesia_$i',
                audio: const {},
              );

        final result = cubit.formatCopyText(ayat: ayat, detail: detail);

        expect(
          result.contains(detail.namaLatin),
          isTrue,
          reason:
              'Iteration $i: output must contain namaLatin "${detail.namaLatin}"',
        );
        expect(
          result.contains(ayat.nomorAyat.toString()),
          isTrue,
          reason:
              'Iteration $i: output must contain nomorAyat "${ayat.nomorAyat}"',
        );
        expect(
          result.contains(ayat.teksArab),
          isTrue,
          reason:
              'Iteration $i: output must contain teksArab "${ayat.teksArab}"',
        );
        expect(
          result.contains(ayat.teksIndonesia),
          isTrue,
          reason:
              'Iteration $i: output must contain teksIndonesia "${ayat.teksIndonesia}"',
        );
      }
    },
  );

  // **Property 14: DetailSurahPageCubit Mark-As-Last-Read Storage Writes**
  // For any (namaLatin, nomorSurah, nomorAyat) combination, markAsLastRead()
  // must call setString(key: 'cacheNamaLatin', value: namaLatin),
  // setInt(key: 'cacheNomorSurah', value: nomorSurah), and
  // setInt(key: 'cacheNomorAyat', value: nomorAyat) with the correct values.
  // **Validates: Requirements 6.4**
  test(
    'Property 14: markAsLastRead writes correct keys and values to storage for all inputs',
    () async {
      // Use a fresh generator seeded set: pull values from generated models
      for (int i = 0; i < 100; i++) {
        // Generate independent mock per iteration to track calls cleanly
        final storageMock = MockLocalStorageService();
        String? capturedNamaLatin;
        int? capturedNomorSurah;
        int? capturedNomorAyat;

        when(
          () => storageMock.setString(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((invocation) async {
          if (invocation.namedArguments[const Symbol('key')] ==
              'cacheNamaLatin') {
            capturedNamaLatin =
                invocation.namedArguments[const Symbol('value')] as String;
          }
        });
        when(
          () => storageMock.setInt(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((invocation) async {
          final key = invocation.namedArguments[const Symbol('key')] as String;
          final value = invocation.namedArguments[const Symbol('value')] as int;
          if (key == 'cacheNomorSurah') capturedNomorSurah = value;
          if (key == 'cacheNomorAyat') capturedNomorAyat = value;
        });

        final detailModel = generateRandomDetailModel();
        final namaLatin = detailModel.namaLatin;
        final nomorSurah = detailModel.nomor;
        // Use nomorAyat from first ayat if available, otherwise use index
        final nomorAyat = detailModel.ayat.isNotEmpty
            ? detailModel.ayat.first.nomorAyat
            : i + 1;

        final cubit = DetailSurahPageCubit(
          storageService: storageMock,
          saveBookmarkUseCase: mockSaveBookmarkUseCase,
        );

        await cubit.markAsLastRead(
          namaLatin: namaLatin,
          nomorSurah: nomorSurah,
          nomorAyat: nomorAyat,
        );

        expect(
          capturedNamaLatin,
          equals(namaLatin),
          reason: 'Iteration $i: setString must store namaLatin="$namaLatin"',
        );
        expect(
          capturedNomorSurah,
          equals(nomorSurah),
          reason:
              'Iteration $i: setInt must store nomorSurah=$nomorSurah under "cacheNomorSurah"',
        );
        expect(
          capturedNomorAyat,
          equals(nomorAyat),
          reason:
              'Iteration $i: setInt must store nomorAyat=$nomorAyat under "cacheNomorAyat"',
        );

        await cubit.close();
      }
    },
  );
}
