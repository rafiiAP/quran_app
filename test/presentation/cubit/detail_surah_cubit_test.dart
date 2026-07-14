import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';
import 'package:quran_app/features/detail_surah/presentation/cubits/detail_surah_cubit/detail_surah_cubit.dart';

import '../../helpers/generators.dart';
import '../../mocks.dart';

void main() {
  late MockGetDetailSurahUseCase mockUsecase;

  const tDetailEntity = DetailEntity(
    nomor: 36,
    nama: 'يسٓ',
    namaLatin: 'Yasin',
    jumlahAyat: 83,
    tempatTurun: 'Mekah',
    arti: 'Yasin',
    deskripsi: 'Surah Yasin',
    audioFull: {'01': 'https://cdn.example.com/36.mp3'},
    ayat: [
      AyatDetailEntity(
        nomorAyat: 1,
        teksArab: 'يسٓ',
        teksLatin: 'Yā Sīn.',
        teksIndonesia: 'Ya Sin.',
        audio: {'01': 'https://cdn.example.com/36/1.mp3'},
      ),
    ],
  );

  setUp(() {
    mockUsecase = MockGetDetailSurahUseCase();
  });

  test('initial state is DetailSurahState.initial()', () {
    final cubit = DetailSurahCubit(usecase: mockUsecase);
    expect(cubit.state, const DetailSurahState.initial());
  });

  blocTest<DetailSurahCubit, DetailSurahState>(
    'emits [loading, success] when usecase returns Right(DetailEntity)',
    setUp: () {
      when(() => mockUsecase.call(nomor: 36))
          .thenAnswer((_) async => const Right(tDetailEntity));
    },
    build: () => DetailSurahCubit(usecase: mockUsecase),
    act: (cubit) => cubit.getPosts(number: 36),
    expect: () => [
      const DetailSurahState.loading(),
      const DetailSurahState.success(tDetailEntity),
    ],
  );

  blocTest<DetailSurahCubit, DetailSurahState>(
    'emits [loading, error] when usecase returns Left(ServerFailure)',
    setUp: () {
      when(() => mockUsecase.call(nomor: 36))
          .thenAnswer((_) async => const Left(ServerFailure('Server error')));
    },
    build: () => DetailSurahCubit(usecase: mockUsecase),
    act: (cubit) => cubit.getPosts(number: 36),
    expect: () => [
      const DetailSurahState.loading(),
      const DetailSurahState.error('Server error'),
    ],
  );

  blocTest<DetailSurahCubit, DetailSurahState>(
    'forwards nomor argument to usecase without modification',
    setUp: () {
      when(() => mockUsecase.call(nomor: 36))
          .thenAnswer((_) async => const Right(tDetailEntity));
    },
    build: () => DetailSurahCubit(usecase: mockUsecase),
    act: (cubit) => cubit.getPosts(number: 36),
    verify: (_) {
      verify(() => mockUsecase.call(nomor: 36)).called(1);
    },
  );

  group('Property Tests', () {
    // Feature: unit-testing, Property 13: DetailSurahCubit State Sequence dan Argument Delegation
    // Validates: Requirements 10.2, 10.4
    test(
        'Property 13: state sequence and argument delegation for any nomor and entity',
        () async {
      for (int i = 0; i < 100; i++) {
        final model = generateRandomDetailModel();
        final entity = model.toEntity();
        final nomor = model.nomor;

        when(() => mockUsecase.call(nomor: nomor))
            .thenAnswer((_) async => Right(entity));

        final cubit = DetailSurahCubit(usecase: mockUsecase);
        final states = <DetailSurahState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.getPosts(number: nomor);
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();
        await cubit.close();

        expect(states, [
          const DetailSurahState.loading(),
          DetailSurahState.success(entity),
        ]);
        verify(() => mockUsecase.call(nomor: nomor)).called(1);
      }
    });
  });
}
