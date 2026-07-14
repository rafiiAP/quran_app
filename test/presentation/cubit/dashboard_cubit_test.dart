import 'package:quran_app/core/constants/config.dart';
import 'package:quran_app/core/di/injection.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/features/dashboard/presentation/cubits/dashboard_cubit/dashboard_cubit.dart';
import 'package:quran_app/features/dashboard/presentation/cubits/dashboard_cubit/dashboard_state.dart';

import '../../mocks.dart';

void main() {
  late MockLocalStorageService mockStorageService;

  setUp(() {
    locator.registerLazySingleton<AppConfig>(AppConfig.new);
    mockStorageService = MockLocalStorageService();
    when(
      () => mockStorageService.setBool(key: 'cacheStarted', value: true),
    ).thenAnswer((_) async {});
  });

  tearDown(() => locator.reset());

  // Requirements: 3.1
  test(
      'initial state has currentIndex = 0 and calls setBool(cacheStarted, true)',
      () {
    final cubit = DashboardCubit(storageService: mockStorageService);
    expect(cubit.state, const DashboardState(currentIndex: 0));
    verify(
      () => mockStorageService.setBool(key: 'cacheStarted', value: true),
    ).called(1);
  });

  // Requirements: 3.2
  blocTest<DashboardCubit, DashboardState>(
    'changeTab(0) emits DashboardState(currentIndex: 0)',
    setUp: () {
      when(
        () => mockStorageService.setBool(key: 'cacheStarted', value: true),
      ).thenAnswer((_) async {});
    },
    build: () => DashboardCubit(storageService: mockStorageService),
    act: (cubit) => cubit.changeTab(0),
    expect: () => [const DashboardState(currentIndex: 0)],
  );

  // Requirements: 3.2
  blocTest<DashboardCubit, DashboardState>(
    'changeTab(1) emits DashboardState(currentIndex: 1)',
    setUp: () {
      when(
        () => mockStorageService.setBool(key: 'cacheStarted', value: true),
      ).thenAnswer((_) async {});
    },
    build: () => DashboardCubit(storageService: mockStorageService),
    act: (cubit) => cubit.changeTab(1),
    expect: () => [const DashboardState(currentIndex: 1)],
  );

  // Requirements: 3.2
  blocTest<DashboardCubit, DashboardState>(
    'changeTab(2) emits DashboardState(currentIndex: 2)',
    setUp: () {
      when(
        () => mockStorageService.setBool(key: 'cacheStarted', value: true),
      ).thenAnswer((_) async {});
    },
    build: () => DashboardCubit(storageService: mockStorageService),
    act: (cubit) => cubit.changeTab(2),
    expect: () => [const DashboardState(currentIndex: 2)],
  );

  // Requirements: 3.3 — sequential tab changes preserve correct state
  blocTest<DashboardCubit, DashboardState>(
    'multiple changeTab calls emit states in correct sequence',
    setUp: () {
      when(
        () => mockStorageService.setBool(key: 'cacheStarted', value: true),
      ).thenAnswer((_) async {});
    },
    build: () => DashboardCubit(storageService: mockStorageService),
    act: (cubit) {
      cubit.changeTab(1);
      cubit.changeTab(2);
      cubit.changeTab(0);
    },
    expect: () => [
      const DashboardState(currentIndex: 1),
      const DashboardState(currentIndex: 2),
      const DashboardState(currentIndex: 0),
    ],
  );
}
