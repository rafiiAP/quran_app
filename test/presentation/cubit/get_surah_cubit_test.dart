import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/surah/presentation/cubits/get_surah_cubit/get_surah_cubit.dart';

import '../../mocks.dart';
import '../../fixtures/surah_fixture.dart';
import '../../helpers/generators.dart';

void main() {
  late MockGetSurahUseCase mockUsecase;

  setUp(() {
    mockUsecase = MockGetSurahUseCase();
  });

  test('initial state is GetSurahState.initial()', () {
    final cubit = GetSurahCubit(usecase: mockUsecase);
    expect(cubit.state, const GetSurahState.initial());
  });

  blocTest<GetSurahCubit, GetSurahState>(
    'emits [loading, success] when usecase returns Right(list)',
    setUp: () {
      when(() => mockUsecase.call())
          .thenAnswer((_) async => const Right([kSurahEntity]));
    },
    build: () => GetSurahCubit(usecase: mockUsecase),
    act: (cubit) => cubit.getPosts(),
    expect: () => [
      const GetSurahState.loading(),
      const GetSurahState.success([kSurahEntity]),
    ],
  );

  blocTest<GetSurahCubit, GetSurahState>(
    'emits [loading, success([])] when usecase returns Right([])',
    setUp: () {
      when(() => mockUsecase.call()).thenAnswer((_) async => const Right([]));
    },
    build: () => GetSurahCubit(usecase: mockUsecase),
    act: (cubit) => cubit.getPosts(),
    expect: () => [
      const GetSurahState.loading(),
      const GetSurahState.success([]),
    ],
  );

  blocTest<GetSurahCubit, GetSurahState>(
    'emits [loading, error(message)] when usecase returns Left(ServerFailure)',
    setUp: () {
      when(() => mockUsecase.call())
          .thenAnswer((_) async => const Left(ServerFailure('Server error')));
    },
    build: () => GetSurahCubit(usecase: mockUsecase),
    act: (cubit) => cubit.getPosts(),
    expect: () => [
      const GetSurahState.loading(),
      const GetSurahState.error('Server error'),
    ],
  );

  group('Property Tests', () {
    // **Validates: Requirements 9.2, 9.4**
    test('Property 11: state sequence [loading, success] for any list',
        () async {
      for (int i = 0; i < 100; i++) {
        final listSize = i % 5;
        final entities = List.generate(
          listSize,
          (_) => generateRandomSurahModel().toEntity(),
        );
        when(() => mockUsecase.call()).thenAnswer((_) async => Right(entities));

        final cubit = GetSurahCubit(usecase: mockUsecase);
        final states = <GetSurahState>[];
        final sub = cubit.stream.listen(states.add);
        cubit.getPosts();
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();
        await cubit.close();

        expect(
          states,
          [const GetSurahState.loading(), GetSurahState.success(entities)],
        );
      }
    });

    // **Validates: Requirements 9.3**
    test('Property 12: state sequence [loading, error] for any message',
        () async {
      for (int i = 0; i < 100; i++) {
        final message = 'Error message $i';
        final failures = [
          ServerFailure(message),
          ConnectionFailure(message),
          ResponseFailure(message),
        ];
        when(() => mockUsecase.call())
            .thenAnswer((_) async => Left(failures[i % 3]));

        final cubit = GetSurahCubit(usecase: mockUsecase);
        final states = <GetSurahState>[];
        final sub = cubit.stream.listen(states.add);
        cubit.getPosts();
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();
        await cubit.close();

        expect(
          states,
          [const GetSurahState.loading(), GetSurahState.error(message)],
        );
      }
    });
  });
}
