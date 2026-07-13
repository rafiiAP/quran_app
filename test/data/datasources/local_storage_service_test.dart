import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/data/datasources/datasource_impl/shared_preferences_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferencesStorageService sut;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    sut = SharedPreferencesStorageService(prefs: prefs);
  });

  // ─────────────────────────────────────────────────────────────
  // Unit tests — specific examples
  // ─────────────────────────────────────────────────────────────

  group('SharedPreferencesStorageService — setString / getString', () {
    test('stores and retrieves a String value', () async {
      await sut.setString(key: 'testKey', value: 'hello');
      expect(sut.getString(key: 'testKey'), equals('hello'));
    });

    test('returns defaultValue when key is absent', () {
      expect(
        sut.getString(key: 'missing', defaultValue: 'default'),
        equals('default'),
      );
    });
  });

  group('SharedPreferencesStorageService — setInt / getInt', () {
    test('stores and retrieves an int value', () async {
      await sut.setInt(key: 'intKey', value: 42);
      expect(sut.getInt(key: 'intKey'), equals(42));
    });

    test('returns defaultValue when key is absent', () {
      expect(sut.getInt(key: 'missing', defaultValue: 99), equals(99));
    });
  });

  group('SharedPreferencesStorageService — setBool / getBool', () {
    test('stores and retrieves a bool value (true)', () async {
      await sut.setBool(key: 'boolKey', value: true);
      expect(sut.getBool(key: 'boolKey'), isTrue);
    });

    test('stores and retrieves a bool value (false)', () async {
      await sut.setBool(key: 'boolKey', value: false);
      expect(sut.getBool(key: 'boolKey'), isFalse);
    });

    test('returns defaultValue when key is absent', () {
      expect(sut.getBool(key: 'missing', defaultValue: true), isTrue);
    });
  });

  group('SharedPreferencesStorageService — remove', () {
    test('removes a previously stored key', () async {
      await sut.setString(key: 'toRemove', value: 'bye');
      await sut.remove(key: 'toRemove');
      expect(
        sut.getString(key: 'toRemove', defaultValue: 'gone'),
        equals('gone'),
      );
    });
  });

  group('SharedPreferencesStorageService — clear', () {
    test('clears all stored values', () async {
      await sut.setString(key: 'k1', value: 'v1');
      await sut.setInt(key: 'k2', value: 2);
      await sut.clear();
      expect(sut.getString(key: 'k1', defaultValue: ''), equals(''));
      expect(sut.getInt(key: 'k2', defaultValue: 0), equals(0));
    });
  });

  // ─────────────────────────────────────────────────────────────
  // Property-based tests — hand-rolled 100-iteration pattern
  // Validates: Requirements 1.1, 1.2, 1.7
  // ─────────────────────────────────────────────────────────────

  group('Property 1: LocalStorageService Round-Trip', () {
    /// **Validates: Requirements 1.1, 1.2**
    ///
    /// For any String key-value pair, writing then reading back must return
    /// the identical value.
    test('Property 1a: String round-trip across 100 varied key-value pairs',
        () async {
      for (int i = 0; i < 100; i++) {
        final key = 'str_key_$i';
        final value = 'value_${i}_abcdef_${i * 7}';
        await sut.setString(key: key, value: value);
        expect(
          sut.getString(key: key),
          equals(value),
          reason: 'String round-trip failed at iteration $i '
              '(key=$key, value=$value)',
        );
      }
    });

    /// **Validates: Requirements 1.1, 1.2**
    ///
    /// For any int key-value pair, writing then reading back must return the
    /// identical value. Covers negative, zero, and large positive integers.
    test('Property 1b: Int round-trip across 100 varied key-value pairs',
        () async {
      for (int i = 0; i < 100; i++) {
        final key = 'int_key_$i';
        // Vary values: positives, negatives, and zero
        final int value;
        if (i == 0) {
          value = 0;
        } else if (i % 3 == 0) {
          value = -i * 13;
        } else {
          value = i * 17;
        }
        await sut.setInt(key: key, value: value);
        expect(
          sut.getInt(key: key),
          equals(value),
          reason: 'Int round-trip failed at iteration $i '
              '(key=$key, value=$value)',
        );
      }
    });

    /// **Validates: Requirements 1.1, 1.2**
    ///
    /// For any bool key-value pair, writing then reading back must return the
    /// identical value. Alternates between true and false across iterations.
    test('Property 1c: Bool round-trip across 100 varied key-value pairs',
        () async {
      for (int i = 0; i < 100; i++) {
        final key = 'bool_key_$i';
        final bool value = i.isEven;
        await sut.setBool(key: key, value: value);
        expect(
          sut.getBool(key: key),
          equals(value),
          reason: 'Bool round-trip failed at iteration $i '
              '(key=$key, value=$value)',
        );
      }
    });

    /// **Validates: Requirements 1.1, 1.2, 1.7**
    ///
    /// Overwriting a key with a new value must always return the latest value,
    /// not an earlier one. Verifies that successive writes are not stale.
    test('Property 1d: Overwrite semantics — last write wins (String)',
        () async {
      const key = 'overwrite_key';
      for (int i = 0; i < 100; i++) {
        final value = 'round_$i';
        await sut.setString(key: key, value: value);
        expect(
          sut.getString(key: key),
          equals(value),
          reason: 'Stale value after overwrite at iteration $i '
              '(expected=$value)',
        );
      }
    });

    /// **Validates: Requirements 1.1, 1.2, 1.7**
    ///
    /// Overwriting a key with a new int value must always return the latest
    /// value. Verifies last-write-wins semantics for integers.
    test('Property 1e: Overwrite semantics — last write wins (Int)', () async {
      const key = 'overwrite_int_key';
      for (int i = 0; i < 100; i++) {
        await sut.setInt(key: key, value: i);
        expect(
          sut.getInt(key: key),
          equals(i),
          reason: 'Stale int value after overwrite at iteration $i',
        );
      }
    });

    /// **Validates: Requirements 1.1, 1.2, 1.7**
    ///
    /// Distinct keys must not interfere with each other. Writing N different
    /// keys and reading them all back must produce the correct isolated values.
    test('Property 1f: Key isolation — distinct keys do not interfere',
        () async {
      // Write all 100 keys first
      for (int i = 0; i < 100; i++) {
        await sut.setString(key: 'iso_str_$i', value: 'iso_val_$i');
        await sut.setInt(key: 'iso_int_$i', value: i * 3);
        await sut.setBool(key: 'iso_bool_$i', value: i.isOdd);
      }
      // Then verify all 100 in a separate pass
      for (int i = 0; i < 100; i++) {
        expect(
          sut.getString(key: 'iso_str_$i'),
          equals('iso_val_$i'),
          reason: 'Key isolation failed for iso_str_$i',
        );
        expect(
          sut.getInt(key: 'iso_int_$i'),
          equals(i * 3),
          reason: 'Key isolation failed for iso_int_$i',
        );
        expect(
          sut.getBool(key: 'iso_bool_$i'),
          equals(i.isOdd),
          reason: 'Key isolation failed for iso_bool_$i',
        );
      }
    });
  });
}
