import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_app/components/function/main_function.dart';

import '../../fixtures/surah_fixture.dart';

/// Concrete test class karena GetStorageComponent adalah mixin
class _TestStorage with GetStorageComponent {}

void main() {
  late _TestStorage component;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (methodCall) async => '.',
    );
  });

  setUp(() async {
    await GetStorage.init();
    GetStorage().erase();
    component = _TestStorage();
  });

  group('String', () {
    test('setString/getString round-trip', () async {
      /// Validates: Requirements 17.1
      await component.setString(cKey: 'name', cValue: 'hello');
      expect(component.getString(cKey: 'name'), 'hello');
    });

    test('getString with missing key returns defaultValue', () {
      /// Validates: Requirements 17.2
      expect(
        component.getString(cKey: 'missing', cDefaultValue: 'default'),
        'default',
      );
    });
  });

  group('int', () {
    test('setInt/getInt round-trip', () async {
      /// Validates: Requirements 17.3
      await component.setInt(cKey: 'count', nValue: 42);
      expect(component.getInt(cKey: 'count', nDefaultValue: 0), 42);
    });

    test('getInt with missing key returns defaultValue', () {
      /// Validates: Requirements 17.4
      expect(component.getInt(cKey: 'missing', nDefaultValue: 99), 99);
    });
  });

  group('bool', () {
    test('setBool/getBool round-trip', () async {
      /// Validates: Requirements 17.5
      await component.setBool(cKey: 'flag', lValue: true);
      expect(component.getBool(cKey: 'flag', lDefaultValue: false), true);
    });
  });

  group('Property Tests', () {
    test('Property 24: String round-trip for any key and value', () async {
      /// **Validates: Requirements 17.1, 17.3, 17.5, 17.6**
      for (int i = 0; i < 100; i++) {
        final key = 'string_key_$i';
        final value = 'value_${i * 3}_test';
        await component.setString(cKey: key, cValue: value);
        expect(component.getString(cKey: key), value);
      }
    });

    test('Property 24: int round-trip for any key and value', () async {
      /// **Validates: Requirements 17.1, 17.3, 17.5, 17.6**
      for (int i = 0; i < 100; i++) {
        final key = 'int_key_$i';
        final value = i * 7 - 50; // negative and positive values
        await component.setInt(cKey: key, nValue: value);
        expect(component.getInt(cKey: key, nDefaultValue: 0), value);
      }
    });

    test('Property 24: bool round-trip for any key and value', () async {
      /// **Validates: Requirements 17.1, 17.3, 17.5, 17.6**
      for (int i = 0; i < 100; i++) {
        final key = 'bool_key_$i';
        final value = i % 2 == 0; // alternating true/false
        await component.setBool(cKey: key, lValue: value);
        expect(component.getBool(cKey: key, lDefaultValue: !value), value);
      }
    });
  });

  group('SurahEntity model', () {
    test('setModel/getModel round-trip', () async {
      /// Validates: Requirements 17.6
      await component.setModel(cKey: 'surah', cValue: kSurahEntity);
      expect(component.getModel(cKey: 'surah'), kSurahEntity);
      // Remove the SurahEntity immediately — GetStorage cannot JSON-encode
      // Dart objects to disk, so we clean up before setUp calls erase().
      await component.clearCache(cKey: 'surah');
    });

    test('getModel returns null for missing key', () {
      /// Validates: Requirements 17.6
      expect(component.getModel(cKey: 'nonexistent_key'), isNull);
    });

    test('getModel returns null when stored value is not SurahEntity',
        () async {
      /// Validates: Requirements 17.6
      await component.setString(cKey: 'not_a_surah', cValue: 'just a string');
      expect(component.getModel(cKey: 'not_a_surah'), isNull);
    });
  });

  group('clearCache and clearAllCache', () {
    test('clearCache removes specific key', () async {
      /// Validates: Requirements 17.7
      await component.setString(cKey: 'to_remove', cValue: 'some value');
      await component.clearCache(cKey: 'to_remove');
      expect(
        component.getString(cKey: 'to_remove', cDefaultValue: 'default'),
        'default',
      );
    });

    test('clearAllCache removes all keys', () async {
      /// Validates: Requirements 17.8
      await component.setString(cKey: 'key1', cValue: 'value1');
      await component.setInt(cKey: 'key2', nValue: 42);
      await component.setBool(cKey: 'key3', lValue: true);
      await component.clearAllCache();
      expect(
        component.getString(cKey: 'key1', cDefaultValue: 'gone'),
        'gone',
      );
      expect(component.getInt(cKey: 'key2', nDefaultValue: -1), -1);
      expect(component.getBool(cKey: 'key3', lDefaultValue: false), false);
    });
  });
}
