import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/error/exceptions.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/surah/data/repositories/surah_repository_impl.dart';
import 'package:quran_app/features/surah/domain/entities/surah_entity.dart';

import '../../../../fixtures/surah_fixture.dart';
import '../../../../mocks.dart';

void main() {
  late MockSurahDatasource mockDatasource;
  late SurahRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockSurahDatasource();
    repository = SurahRepositoryImpl(datasource: mockDatasource);
  });

  group('SurahRepositoryImpl.getSurah', () {
    test('returns Right with mapped entities on success', () async {
      when(() => mockDatasource.getSurah())
          .thenAnswer((_) async => [kSurahModel]);

      final result = await repository.getSurah();

      expect(result.isRight(), isTrue);
      final data = result.match((_) => <SurahEntity>[], (d) => d);
      expect(data.length, 1);
      expect(data.first, kSurahEntity);
    });

    test('returns Right with empty list when datasource returns empty',
        () async {
      when(() => mockDatasource.getSurah()).thenAnswer((_) async => []);

      final result = await repository.getSurah();

      expect(result.isRight(), isTrue);
      final data = result.match((_) => <SurahEntity>[], (d) => d);
      expect(data, isEmpty);
    });

    test('returns Left(ConnectionFailure) when ConnectionException is thrown',
        () async {
      when(() => mockDatasource.getSurah()).thenThrow(
        const ConnectionException('Connection timeout'),
      );

      final result = await repository.getSurah();

      expect(result.isLeft(), isTrue);
      final failure = result.match((f) => f, (_) => null);
      expect(failure, isA<ConnectionFailure>());
      expect(failure!.message, 'Connection timeout');
    });

    test('returns Left(ServerFailure) when ServerException is thrown',
        () async {
      when(() => mockDatasource.getSurah()).thenThrow(
        const ServerException('Parse error'),
      );

      final result = await repository.getSurah();

      expect(result.isLeft(), isTrue);
      final failure = result.match((f) => f, (_) => null);
      expect(failure, isA<ServerFailure>());
      expect(failure!.message, 'Parse error');
    });

    test('returns Left(ServerFailure) when generic exception is thrown',
        () async {
      when(() => mockDatasource.getSurah()).thenThrow(Exception('Unknown'));

      final result = await repository.getSurah();

      expect(result.isLeft(), isTrue);
      final failure = result.match((f) => f, (_) => null);
      expect(failure, isA<ServerFailure>());
      expect(failure!.message, contains('Unknown'));
    });
  });
}
