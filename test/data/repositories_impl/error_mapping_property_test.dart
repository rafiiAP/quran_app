import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/error/exceptions.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/jadwal_sholat/data/repositories/jadwal_sholat_repository_impl.dart';
import 'package:quran_app/features/surah/data/repositories/surah_repository_impl.dart';

import '../../mocks.dart';

/// **Validates: Requirements 15.2, 15.3**
///
/// Property 5: Error Mapping Chain Preserves Semantics
/// - ConnectionException always produces ConnectionFailure
/// - ServerException always produces ServerFailure
/// - Generic exceptions (non-typed) always produce ServerFailure
void main() {
  late MockSurahDatasource mockSurahDatasource;
  late MockJadwalSholatDatasource mockJadwalSholatDatasource;
  late SurahRepositoryImpl surahRepository;
  late JadwalSholatRepositoryImpl jadwalSholatRepository;

  setUp(() {
    mockSurahDatasource = MockSurahDatasource();
    mockJadwalSholatDatasource = MockJadwalSholatDatasource();
    surahRepository = SurahRepositoryImpl(datasource: mockSurahDatasource);
    jadwalSholatRepository =
        JadwalSholatRepositoryImpl(datasource: mockJadwalSholatDatasource);
  });

  /// Helper: generates a random ConnectionException.
  ConnectionException generateConnectionException(Random random) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789 ';
    final msgLength = random.nextInt(30) + 5;
    final message = String.fromCharCodes(
      Iterable.generate(
        msgLength,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
    return ConnectionException(message);
  }

  /// Helper: generates a random ServerException.
  ServerException generateServerException(Random random) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789 ';
    final msgLength = random.nextInt(30) + 5;
    final message = String.fromCharCodes(
      Iterable.generate(
        msgLength,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
    return ServerException(message);
  }

  /// Helper: generates a random generic exception for fallback path.
  Exception generateGenericException(Random random) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789 ';
    final msgLength = random.nextInt(30) + 5;
    final message = String.fromCharCodes(
      Iterable.generate(
        msgLength,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );

    switch (random.nextInt(3)) {
      case 0:
        return FormatException(message);
      case 1:
        return Exception('StateError: $message');
      default:
        return Exception(message);
    }
  }

  group('Property 5: Error Mapping Chain Preserves Semantics', () {
    test(
      'ConnectionException always produces ConnectionFailure in SurahRepositoryImpl.getSurah '
      'for 100 random scenarios',
      () async {
        final random = Random(42);
        for (int i = 0; i < 100; i++) {
          final exception = generateConnectionException(random);

          when(() => mockSurahDatasource.getSurah()).thenThrow(exception);

          final result = await surahRepository.getSurah();

          expect(
            result.isLeft(),
            isTrue,
            reason:
                'iteration $i: ConnectionException should produce Left but got Right',
          );

          final failure = result.match((f) => f, (_) => null);
          expect(
            failure,
            isA<ConnectionFailure>(),
            reason: 'iteration $i: ConnectionException("${exception.message}") '
                'should map to ConnectionFailure but got ${failure.runtimeType}',
          );
        }
      },
    );

    test(
      'ServerException always produces ServerFailure in SurahRepositoryImpl.getSurah '
      'for 100 random scenarios',
      () async {
        final random = Random(43);
        for (int i = 0; i < 100; i++) {
          final exception = generateServerException(random);

          when(() => mockSurahDatasource.getSurah()).thenThrow(exception);

          final result = await surahRepository.getSurah();

          expect(
            result.isLeft(),
            isTrue,
            reason:
                'iteration $i: ServerException should produce Left but got Right',
          );

          final failure = result.match((f) => f, (_) => null);
          expect(
            failure,
            isA<ServerFailure>(),
            reason: 'iteration $i: ServerException("${exception.message}") '
                'should map to ServerFailure but got ${failure.runtimeType}',
          );
        }
      },
    );

    test(
      'ConnectionException always produces ConnectionFailure in JadwalSholatRepositoryImpl '
      'for 100 random scenarios',
      () async {
        final random = Random(44);
        for (int i = 0; i < 100; i++) {
          final exception = generateConnectionException(random);
          final lat = (random.nextDouble() * 180) - 90;
          final lng = (random.nextDouble() * 360) - 180;
          final date =
              '2024-${(random.nextInt(12) + 1).toString().padLeft(2, '0')}-${(random.nextInt(28) + 1).toString().padLeft(2, '0')}';

          when(
            () => mockJadwalSholatDatasource.getJadwalSholat(
              latitude: lat,
              longitude: lng,
              date: date,
            ),
          ).thenThrow(exception);

          final result = await jadwalSholatRepository.getJadwalSholat(
            latitude: lat,
            longitude: lng,
            date: date,
          );

          expect(
            result.isLeft(),
            isTrue,
            reason:
                'iteration $i: ConnectionException should produce Left but got Right',
          );

          final failure = result.match((f) => f, (_) => null);
          expect(
            failure,
            isA<ConnectionFailure>(),
            reason: 'iteration $i: ConnectionException("${exception.message}") '
                'should map to ConnectionFailure but got ${failure.runtimeType}',
          );
        }
      },
    );

    test(
      'ServerException always produces ServerFailure in JadwalSholatRepositoryImpl '
      'for 100 random scenarios',
      () async {
        final random = Random(45);
        for (int i = 0; i < 100; i++) {
          final exception = generateServerException(random);
          final lat = (random.nextDouble() * 180) - 90;
          final lng = (random.nextDouble() * 360) - 180;
          final date =
              '2024-${(random.nextInt(12) + 1).toString().padLeft(2, '0')}-${(random.nextInt(28) + 1).toString().padLeft(2, '0')}';

          when(
            () => mockJadwalSholatDatasource.getJadwalSholat(
              latitude: lat,
              longitude: lng,
              date: date,
            ),
          ).thenThrow(exception);

          final result = await jadwalSholatRepository.getJadwalSholat(
            latitude: lat,
            longitude: lng,
            date: date,
          );

          expect(
            result.isLeft(),
            isTrue,
            reason:
                'iteration $i: ServerException should produce Left but got Right',
          );

          final failure = result.match((f) => f, (_) => null);
          expect(
            failure,
            isA<ServerFailure>(),
            reason: 'iteration $i: ServerException("${exception.message}") '
                'should map to ServerFailure but got ${failure.runtimeType}',
          );
        }
      },
    );

    test(
      'Generic exceptions produce ServerFailure in SurahRepositoryImpl.getSurah '
      'for 100 random scenarios',
      () async {
        final random = Random(46);
        for (int i = 0; i < 100; i++) {
          final exception = generateGenericException(random);

          when(() => mockSurahDatasource.getSurah()).thenThrow(exception);

          final result = await surahRepository.getSurah();

          expect(
            result.isLeft(),
            isTrue,
            reason:
                'iteration $i: Exception("$exception") should produce Left but got Right',
          );

          final failure = result.match((f) => f, (_) => null);
          expect(
            failure,
            isA<ServerFailure>(),
            reason: 'iteration $i: Exception("$exception") '
                'should map to ServerFailure but got ${failure.runtimeType}',
          );
        }
      },
    );

    test(
      'Generic exceptions produce ServerFailure in JadwalSholatRepositoryImpl '
      'for 100 random scenarios',
      () async {
        final random = Random(47);
        for (int i = 0; i < 100; i++) {
          final exception = generateGenericException(random);
          final lat = (random.nextDouble() * 180) - 90;
          final lng = (random.nextDouble() * 360) - 180;
          final date =
              '2024-${(random.nextInt(12) + 1).toString().padLeft(2, '0')}-${(random.nextInt(28) + 1).toString().padLeft(2, '0')}';

          when(
            () => mockJadwalSholatDatasource.getJadwalSholat(
              latitude: lat,
              longitude: lng,
              date: date,
            ),
          ).thenThrow(exception);

          final result = await jadwalSholatRepository.getJadwalSholat(
            latitude: lat,
            longitude: lng,
            date: date,
          );

          expect(
            result.isLeft(),
            isTrue,
            reason:
                'iteration $i: Exception("$exception") should produce Left but got Right',
          );

          final failure = result.match((f) => f, (_) => null);
          expect(
            failure,
            isA<ServerFailure>(),
            reason: 'iteration $i: Exception("$exception") '
                'should map to ServerFailure but got ${failure.runtimeType}',
          );
        }
      },
    );
  });
}
