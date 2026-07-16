import 'package:quran_app/core/constants/config.dart';
import 'package:quran_app/core/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/features/dashboard/presentation/cubits/dashboard_cubit/dashboard_cubit.dart';

import '../../mocks.dart';

void main() {
  late MockLocalStorageService mockStorage;

  setUp(() {
    locator.registerLazySingleton<AppConfig>(AppConfig.new);
    mockStorage = MockLocalStorageService();
    when(
      () => mockStorage.setBool(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});
  });

  tearDown(() => locator.reset());

  /// **Validates: Requirements 3.1, 3.2**
  ///
  /// Property 3: DashboardCubit Tab Selection
  /// For any valid index (0, 1, 2), `changeTab(index)` must emit state
  /// with matching `currentIndex`.
  test(
    'Property 3: changeTab(index) always emits DashboardState(currentIndex: index) '
    'for all valid indices — 100 iterations',
    () async {
      const validIndices = [0, 1, 2];

      for (int iteration = 0; iteration < 100; iteration++) {
        final index = validIndices[iteration % validIndices.length];

        final cubit = DashboardCubit(storageService: mockStorage);

        cubit.changeTab(index);

        expect(
          cubit.state,
          equals(DashboardState(currentIndex: index)),
          reason: 'iteration $iteration: changeTab($index) should emit '
              'DashboardState(currentIndex: $index) but got ${cubit.state}',
        );

        await cubit.close();
      }
    },
  );
}
