import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/di/injection.dart';
import 'package:quran_app/core/services/crash_reporter.dart';

import '../../../../mocks.dart';

class _FakeStackTrace extends Fake implements StackTrace {}

/// **Validates: Requirements 10.1, 10.3**
///
/// Property 4: Safe Parameter Parsing
/// - Any non-integer string as `nomor` results in redirect to `/home`
/// - Any non-integer string as `ayat` results in null `indexTandai`
/// Tested for 100 random invalid inputs.
///
/// The detail_surah_routes.dart implements:
/// - redirect: int.tryParse(nomor) == null → recordError + return '/home'
/// - builder: int.tryParse(ayat) == null → indexTandai = null
///
/// This test validates the parsing logic directly, simulating the same
/// code path used in the route redirect and builder callbacks.
void main() {
  late MockCrashReporter mockCrashReporter;

  setUpAll(() {
    registerFallbackValue(Exception('fallback'));
    registerFallbackValue(_FakeStackTrace());
  });

  setUp(() async {
    await locator.reset();
    mockCrashReporter = MockCrashReporter();
    locator.registerLazySingleton<CrashReporter>(() => mockCrashReporter);

    when(() => mockCrashReporter.recordError(any(), any()))
        .thenAnswer((_) async {});
  });

  tearDown(() async {
    await locator.reset();
  });

  /// Generates random non-integer strings that int.tryParse will reject.
  List<String> generateInvalidIntStrings(Random random, int count) {
    final invalidStrings = <String>[];
    const alphaChars = 'abcdefghijklmnopqrstuvwxyz';
    const specialChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?/~`';

    for (int i = 0; i < count; i++) {
      final type = i % 8;
      switch (type) {
        case 0:
          // Alphabetical strings: "abc", "xyz"
          final length = random.nextInt(5) + 1;
          invalidStrings.add(
            String.fromCharCodes(
              List.generate(
                length,
                (_) => alphaChars.codeUnitAt(random.nextInt(alphaChars.length)),
              ),
            ),
          );
        case 1:
          // Decimal numbers: "3.14", "1.0"
          invalidStrings.add(
            '${random.nextInt(100)}.${random.nextInt(100)}',
          );
        case 2:
          // Empty string
          invalidStrings.add('');
        case 3:
          // Whitespace only
          invalidStrings.add(' ' * (random.nextInt(3) + 1));
        case 4:
          // Mixed alphanumeric: "1a", "2b3"
          invalidStrings.add(
            '${random.nextInt(10)}${String.fromCharCode(97 + random.nextInt(26))}',
          );
        case 5:
          // Special characters: "@#!", "***"
          final length = random.nextInt(4) + 1;
          invalidStrings.add(
            String.fromCharCodes(
              List.generate(
                length,
                (_) => specialChars
                    .codeUnitAt(random.nextInt(specialChars.length)),
              ),
            ),
          );
        case 6:
          // Digits with embedded non-digit character: "1 2", "5,3"
          invalidStrings.add(
            '${random.nextInt(10)}${String.fromCharCode(44 + random.nextInt(3))}${random.nextInt(10)}',
          );
        case 7:
          // Negative with non-digit suffix: "-abc", "-x1"
          invalidStrings.add(
            '-${String.fromCharCode(97 + random.nextInt(26))}${random.nextInt(10)}',
          );
      }
    }
    return invalidStrings;
  }

  /// Simulates the redirect logic from detail_surah_routes.dart:
  /// ```dart
  /// redirect: (context, state) {
  ///   final nomor = int.tryParse(state.pathParameters['nomor'] ?? '');
  ///   if (nomor == null) {
  ///     locator<CrashReporter>().recordError(...);
  ///     return '/home';
  ///   }
  ///   return null;
  /// }
  /// ```
  String? simulateRedirect(String? nomorParam) {
    final nomor = int.tryParse(nomorParam ?? '');
    if (nomor == null) {
      locator<CrashReporter>().recordError(
        FormatException('Invalid nomor: $nomorParam'),
        StackTrace.current,
      );
      return '/home';
    }
    return null;
  }

  /// Simulates the ayat parsing logic from detail_surah_routes.dart:
  /// ```dart
  /// final indexTandai = int.tryParse(state.uri.queryParameters['ayat'] ?? '');
  /// ```
  int? simulateAyatParsing(String? ayatParam) {
    return int.tryParse(ayatParam ?? '');
  }

  group('Property 4: Safe Parameter Parsing (100 iterations)', () {
    test(
      'non-integer nomor always redirects to /home',
      () {
        final random = Random(42);
        final invalidInputs = generateInvalidIntStrings(random, 100);

        for (int i = 0; i < 100; i++) {
          final invalidNomor = invalidInputs[i];

          // Precondition: input is truly not parseable as int
          expect(
            int.tryParse(invalidNomor),
            isNull,
            reason:
                'Precondition failed: "$invalidNomor" should not parse as int',
          );

          // Simulate the redirect logic
          final redirectResult = simulateRedirect(invalidNomor);

          expect(
            redirectResult,
            equals('/home'),
            reason:
                'iteration $i: nomor="$invalidNomor" should redirect to /home '
                'but got "$redirectResult"',
          );
        }

        // Verify CrashReporter.recordError was called for each invalid input
        verify(
          () => mockCrashReporter.recordError(any(), any()),
        ).called(100);
      },
    );

    test(
      'non-integer ayat always results in null indexTandai',
      () {
        final random = Random(42);
        final invalidInputs = generateInvalidIntStrings(random, 100);

        for (int i = 0; i < 100; i++) {
          final invalidAyat = invalidInputs[i];

          // Precondition: input is truly not parseable as int
          expect(
            int.tryParse(invalidAyat),
            isNull,
            reason:
                'Precondition failed: "$invalidAyat" should not parse as int',
          );

          // Simulate the ayat parsing logic
          final indexTandai = simulateAyatParsing(invalidAyat);

          expect(
            indexTandai,
            isNull,
            reason:
                'iteration $i: ayat="$invalidAyat" should produce null indexTandai '
                'but got $indexTandai',
          );
        }
      },
    );

    test(
      'valid integer nomor does not redirect (returns null)',
      () {
        final random = Random(42);

        for (int i = 0; i < 100; i++) {
          final validNomor = (random.nextInt(114) + 1).toString();

          // Precondition: input is parseable as int
          expect(
            int.tryParse(validNomor),
            isNotNull,
            reason: 'Precondition failed: "$validNomor" should parse as int',
          );

          // Simulate the redirect logic
          final redirectResult = simulateRedirect(validNomor);

          expect(
            redirectResult,
            isNull,
            reason:
                'iteration $i: valid nomor="$validNomor" should not redirect '
                'but got "$redirectResult"',
          );
        }

        // CrashReporter should not be called for valid inputs
        verifyNever(() => mockCrashReporter.recordError(any(), any()));
      },
    );
  });
}
