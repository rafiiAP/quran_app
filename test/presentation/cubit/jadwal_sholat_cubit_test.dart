import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/jadwal_sholat/presentation/cubits/jadwal_sholat_cubit/jadwal_sholat_cubit.dart';

import '../../mocks.dart';
import '../../fixtures/jadwal_sholat_fixture.dart';
import '../../helpers/generators.dart';

void main() {
  late MockGetJadwalSholatUseCase mockUsecase;
  final tEntity = kJadwalSholatModel.toEntity();

  setUp(() {
    mockUsecase = MockGetJadwalSholatUseCase();
  });

  test('initial state is JadwalSholatState.initial()', () {
    final cubit = JadwalSholatCubit(usecase: mockUsecase);
    expect(cubit.state, const JadwalSholatState.initial());
  });

  blocTest<JadwalSholatCubit, JadwalSholatState>(
    'emits [loading, success] when usecase returns Right(JadwalSholatEntity)',
    setUp: () {
      when(
        () => mockUsecase.call(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
          date: any(named: 'date'),
        ),
      ).thenAnswer((_) async => Right(tEntity));
    },
    build: () => JadwalSholatCubit(usecase: mockUsecase),
    act: (cubit) => cubit.getPosts(
      latitude: -6.2,
      longitude: 106.8,
      date: '2024-01-15',
    ),
    expect: () => [
      const JadwalSholatState.loading(),
      JadwalSholatState.success(tEntity),
    ],
  );

  blocTest<JadwalSholatCubit, JadwalSholatState>(
    'emits [loading, error(timeout)] when usecase returns Left(ConnectionFailure)',
    setUp: () {
      when(
        () => mockUsecase.call(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
          date: any(named: 'date'),
        ),
      ).thenAnswer((_) async => const Left(ConnectionFailure('timeout')));
    },
    build: () => JadwalSholatCubit(usecase: mockUsecase),
    act: (cubit) => cubit.getPosts(
      latitude: -6.2,
      longitude: 106.8,
      date: '2024-01-15',
    ),
    expect: () => [
      const JadwalSholatState.loading(),
      const JadwalSholatState.error('timeout'),
    ],
  );

  blocTest<JadwalSholatCubit, JadwalSholatState>(
    'forwards latitude, longitude, date to usecase exactly',
    setUp: () {
      when(
        () => mockUsecase.call(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
          date: any(named: 'date'),
        ),
      ).thenAnswer((_) async => Right(tEntity));
    },
    build: () => JadwalSholatCubit(usecase: mockUsecase),
    act: (cubit) => cubit.getPosts(
      latitude: -7.25,
      longitude: 112.75,
      date: '2024-06-20',
    ),
    verify: (_) {
      verify(
        () => mockUsecase.call(
          latitude: -7.25,
          longitude: 112.75,
          date: '2024-06-20',
        ),
      ).called(1);
    },
  );

  group('Property Tests', () {
    test(
        'Property 14: state sequence and argument delegation for any (lat, lng, date)',
        () async {
      // Feature: unit-testing, Property 14: JadwalSholatCubit State Sequence dan Argument Delegation
      // Validates: Requirements 11.2, 11.4
      for (int i = 0; i < 100; i++) {
        final model = generateRandomJadwalSholatModel();
        final entity = model.toEntity();
        final lat = (i % 180) - 90.0; // -90 to 89
        final lng = (i % 360) - 180.0; // -180 to 179
        final date =
            '2024-${(i % 12 + 1).toString().padLeft(2, '0')}-${(i % 28 + 1).toString().padLeft(2, '0')}';

        when(
          () => mockUsecase.call(
            latitude: lat,
            longitude: lng,
            date: date,
          ),
        ).thenAnswer((_) async => Right(entity));

        final cubit = JadwalSholatCubit(usecase: mockUsecase);
        final states = <JadwalSholatState>[];
        final sub = cubit.stream.listen(states.add);
        cubit.getPosts(latitude: lat, longitude: lng, date: date);
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();
        await cubit.close();

        expect(states, [
          const JadwalSholatState.loading(),
          JadwalSholatState.success(entity),
        ]);
        verify(
          () => mockUsecase.call(
            latitude: lat,
            longitude: lng,
            date: date,
          ),
        ).called(1);
      }
    });
  });
}
