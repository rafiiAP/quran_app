import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/surah/domain/entities/surah_entity.dart';
import 'package:quran_app/features/surah/domain/usecases/get_surah_usecase.dart';

import '../../../../fixtures/surah_fixture.dart';
import '../../../../mocks.dart';

void main() {
  late MockSurahRepository mockRepository;
  late GetSurahUseCase useCase;

  setUp(() {
    mockRepository = MockSurahRepository();
    useCase = GetSurahUseCase(mockRepository);
  });

  group('GetSurahUseCase', () {
    test('delegates to SurahRepository.getSurah and returns Right on success',
        () async {
      when(() => mockRepository.getSurah()).thenAnswer(
        (_) async => const Right([kSurahEntity]),
      );

      final result = await useCase.call();

      expect(result.isRight(), isTrue);
      final data = result.match((_) => <SurahEntity>[], (d) => d);
      expect(data, [kSurahEntity]);
      verify(() => mockRepository.getSurah()).called(1);
    });

    test('delegates to SurahRepository.getSurah and returns Left on failure',
        () async {
      when(() => mockRepository.getSurah()).thenAnswer(
        (_) async => const Left(ConnectionFailure('No internet')),
      );

      final result = await useCase.call();

      expect(result.isLeft(), isTrue);
      final failure = result.match((f) => f, (_) => null);
      expect(failure, isA<ConnectionFailure>());
      expect(failure!.message, 'No internet');
      verify(() => mockRepository.getSurah()).called(1);
    });

    test('does not call any other repository method', () async {
      when(() => mockRepository.getSurah()).thenAnswer(
        (_) async => const Right([]),
      );

      await useCase.call();

      verify(() => mockRepository.getSurah()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
