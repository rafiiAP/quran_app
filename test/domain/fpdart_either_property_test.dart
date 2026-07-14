import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/failure.dart';

void main() {
  /// **Validates: Requirements 6.5, 6.6**
  ///
  /// Property 3: fpdart Either Construction and Match Equivalence
  /// For any value, Right(value).match invokes rightFn with the value,
  /// and Left(Failure(message)).match invokes leftFn with the failure.

  test(
    'Property 3: Right(value).match invokes rightFn for 100 random values',
    () {
      final random = Random();
      for (int i = 0; i < 100; i++) {
        final value = random.nextInt(10000);
        final either = Right<Failure, int>(value);

        int? receivedRight;
        String? receivedLeft;
        either.match(
          (failure) => receivedLeft = failure.message,
          (data) => receivedRight = data,
        );

        expect(
          receivedRight,
          equals(value),
          reason:
              'iteration $i: Right($value).match should invoke rightFn with $value '
              'but receivedRight was $receivedRight',
        );
        expect(
          receivedLeft,
          isNull,
          reason: 'iteration $i: Right($value).match should not invoke leftFn '
              'but receivedLeft was $receivedLeft',
        );
      }
    },
  );

  test(
    'Property 3: Left(Failure(message)).match invokes leftFn for 100 random values',
    () {
      final random = Random();
      const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
      for (int i = 0; i < 100; i++) {
        // Generate a random failure message
        final length = random.nextInt(20) + 1;
        final message = String.fromCharCodes(
          Iterable.generate(
            length,
            (_) => chars.codeUnitAt(random.nextInt(chars.length)),
          ),
        );
        final failure = ConnectionFailure(message);
        final either = Left<Failure, int>(failure);

        int? receivedRight;
        Failure? receivedLeft;
        either.match(
          (f) => receivedLeft = f,
          (data) => receivedRight = data,
        );

        expect(
          receivedLeft,
          equals(failure),
          reason:
              'iteration $i: Left(ConnectionFailure("$message")).match should invoke leftFn '
              'with the failure but receivedLeft was $receivedLeft',
        );
        expect(
          receivedLeft?.message,
          equals(message),
          reason:
              'iteration $i: leftFn should receive failure with message "$message" '
              'but got "${receivedLeft?.message}"',
        );
        expect(
          receivedRight,
          isNull,
          reason: 'iteration $i: Left(Failure).match should not invoke rightFn '
              'but receivedRight was $receivedRight',
        );
      }
    },
  );
}
