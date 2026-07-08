import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/data/constant/config.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';
import 'package:quran_app/injection.dart';
import 'package:quran_app/presentation/controller/dashboard/home_getx.dart';

import '../../fixtures/surah_fixture.dart';
import '../../helpers/generators.dart';

void main() {
  late HomeGetx controller;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock path_provider channel for GetStorage
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return '.';
        }
        return null;
      },
    );
  });

  setUp(() async {
    await GetStorage.init();
    GetStorage().erase();

    // Register AppConfig (alias `config`) in GetIt if not already registered
    if (!locator.isRegistered<AppConfig>()) {
      locator.registerLazySingleton<AppConfig>(() => AppConfig());
    }

    // Register MainFunction (alias `C`) in GetIt if not already registered
    if (!locator.isRegistered<MainFunction>()) {
      locator.registerLazySingleton<MainFunction>(() => MainFunction());
    }

    controller = HomeGetx();
  });

  tearDown(() {
    Get.reset();
  });

  group('getLastRead()', () {
    test('reads values from storage when present', () {
      // Write values directly to GetStorage
      GetStorage().write('cacheNamaLatin', 'Al-Fatihah');
      GetStorage().write('cacheNomorSurah', 1);
      GetStorage().write('cacheNomorAyat', 5);

      controller.getLastRead();

      expect(controller.cNamaLatin.value, 'Al-Fatihah');
      expect(controller.nNomorSurah.value, 1);
      expect(controller.nNomorAyat.value, 5);
    });

    test('uses default values when storage is empty', () {
      // Storage is already erased in setUp, so no values exist
      controller.getLastRead();

      expect(controller.cNamaLatin.value, '');
      expect(controller.nNomorSurah.value, 0);
      expect(controller.nNomorAyat.value, 0);
    });
  });

  group('onSuccesGetSurah()', () {
    test('updates surahList with given data', () {
      final List<SurahEntity> testData = [
        const SurahEntity(
          nomor: 1,
          nama: 'سُورَةُ الْفَاتِحَةِ',
          namaLatin: 'Al-Fatihah',
          jumlahAyat: 7,
          tempatTurun: 'Mekah',
          arti: 'Pembuka',
          deskripsi: 'Surah pertama',
          audioFull: {'01': 'https://example.com/1.mp3'},
        ),
        const SurahEntity(
          nomor: 2,
          nama: 'سُورَةُ البَقَرَةِ',
          namaLatin: 'Al-Baqarah',
          jumlahAyat: 286,
          tempatTurun: 'Madinah',
          arti: 'Sapi',
          deskripsi: 'Surah kedua',
          audioFull: {'01': 'https://example.com/2.mp3'},
        ),
      ];

      controller.onSuccesGetSurah(testData);

      expect(controller.surahList.value, testData);
      expect(controller.surahList.value.length, 2);
    });
  });

  group('toLastRead()', () {
    test('index: 0 keeps isToLastRead false', () async {
      // toLastRead(index: 0) enters the else branch which tries Get.snackbar.
      // Get.snackbar requires a navigation overlay — which doesn't exist in
      // unit tests. The error is thrown asynchronously in GetX internal queue.
      // Use runZonedGuarded to suppress the uncaught async error.
      final completer = Completer<void>();

      runZonedGuarded(
        () {
          controller.toLastRead(index: 0);
          // Give async code time to execute
          Future.delayed(const Duration(milliseconds: 100), () {
            completer.complete();
          });
        },
        (error, stack) {
          // Suppress the expected Get.snackbar error
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
      );

      await completer.future;

      // isToLastRead should remain false (only set in if-branch when index != 0)
      expect(controller.isToLastRead.value, false);
    });

    test('index > 0 sets isToLastRead to true', () {
      // toLastRead with index > 0 sets isToLastRead.value = true synchronously
      // before hitting Get.context! which throws.
      expect(
        () => controller.toLastRead(index: 5),
        throwsA(isA<TypeError>()),
      );

      expect(controller.isToLastRead.value, true);
    });
  });

  group('getDetailSurah()', () {
    test(
        'resets isToLastRead to false synchronously before context access '
        '(Validates: Requirement 19.1)', () async {
      // Arrange: set isToLastRead to true to confirm it gets reset
      controller.isToLastRead.value = true;
      expect(controller.isToLastRead.value, true);

      // Act: getDetailSurah is an async void method. It sets
      // isToLastRead.value = false on the very first line (synchronous), then
      // immediately hits Get.context! which throws "Null check operator used
      // on a null value" as an unhandled async error in unit-test environment.
      // Use runZonedGuarded to capture and suppress the expected crash so the
      // test can proceed to the assertion.
      final completer = Completer<void>();

      runZonedGuarded(
        () {
          controller.getDetailSurah(kSurahEntity);
          // Schedule the assertion after the current microtask queue drains
          // to ensure the synchronous portion of getDetailSurah has run.
          Future.microtask(() {
            if (!completer.isCompleted) completer.complete();
          });
        },
        (error, stack) {
          // Expected: Get.context! null-check throw propagated as async error.
          if (!completer.isCompleted) completer.complete();
        },
      );

      await completer.future;

      // Assert: isToLastRead must have been set to false (reset happened
      // synchronously before the context access that threw).
      expect(controller.isToLastRead.value, false);
    });
  });

  group('Property Tests', () {
    test('Property 15: getLastRead reads any values from storage', () {
      // Feature: unit-testing, Property 15: last-read state dari storage
      // Validates: Requirements 12.1
      for (int i = 0; i < 100; i++) {
        final namaLatin = 'Surah-$i';
        final nomorSurah = i + 1;
        final nomorAyat = i * 2;

        GetStorage().write('cacheNamaLatin', namaLatin);
        GetStorage().write('cacheNomorSurah', nomorSurah);
        GetStorage().write('cacheNomorAyat', nomorAyat);

        controller.getLastRead();

        expect(controller.cNamaLatin.value, namaLatin);
        expect(controller.nNomorSurah.value, nomorSurah);
        expect(controller.nNomorAyat.value, nomorAyat);
      }
    });

    test('Property 16: onSuccesGetSurah updates surahList for any list', () {
      // Feature: unit-testing, Property 16: SurahList update
      // Validates: Requirements 12.3
      for (int i = 0; i < 100; i++) {
        final listSize = i % 5;
        final list = List.generate(
            listSize, (_) => generateRandomSurahModel().toEntity());
        controller.onSuccesGetSurah(list);
        expect(controller.surahList.value, list);
      }
    });

    test('Property 17: toLastRead sets isToLastRead true for any n > 0', () {
      // Feature: unit-testing, Property 17: toLastRead dengan index positif
      // Validates: Requirements 12.5
      for (int i = 1; i <= 100; i++) {
        controller.isToLastRead.value = false; // reset
        // toLastRead sets isToLastRead.value = true synchronously before
        // hitting Get.context! which throws.
        expect(
          () => controller.toLastRead(index: i),
          throwsA(isA<TypeError>()),
        );
        expect(controller.isToLastRead.value, true);
      }
    });
  });
}
