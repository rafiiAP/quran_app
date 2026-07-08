import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/data/constant/config.dart';
import 'package:quran_app/data/model/set_notif_model.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';
import 'package:quran_app/injection.dart';
import 'package:quran_app/presentation/controller/jadwal_sholat/jadwal_sholat_getx.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  late JadwalSholatGetx controller;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Initialize timezone database so scheduleNotification() can call
    // tz.getLocation() without throwing.
    tz.initializeTimeZones();

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

    // Mock flutter_timezone channel so scheduleNotification() doesn't throw
    // MissingPluginException in the test environment.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter_timezone'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'getLocalTimezone') {
          return 'UTC';
        }
        return null;
      },
    );

    // Mock flutter_local_notifications channel so zonedSchedule() doesn't
    // throw MissingPluginException.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dexterous.com/flutter/local_notifications'),
      (MethodCall methodCall) async => null,
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

    controller = JadwalSholatGetx();
  });

  tearDown(() {
    Get.reset();
  });

  group('formatDuration()', () {
    test('formats Duration(hours: 2, minutes: 30, seconds: 5) as "02:30:05"',
        () {
      // Validates: Requirements 15.1
      expect(
        controller
            .formatDuration(const Duration(hours: 2, minutes: 30, seconds: 5)),
        '02:30:05',
      );
    });

    test('formats Duration.zero as "00:00:00"', () {
      // Validates: Requirements 15.2
      expect(controller.formatDuration(Duration.zero), '00:00:00');
    });
  });

  group('getTimeText()', () {
    test('returns "-" when vaJadwal is empty', () {
      // Validates: Requirements 15.3
      controller.vaJadwal.clear();
      expect(controller.getTimeText(), '-');
    });
  });

  group('onSuccess()', () {
    test('parses fajr "05:00" into first element with hour: 5, minute: 0', () {
      // Validates: Requirements 15.4
      // onSuccess sets vaJadwal synchronously, then calls loadAlarmStatus
      // (reads GetStorage — initialized above), startTimer and updateSholat
      // (fire async Future.delayed — won't block this test).
      const entity = JadwalSholatEntity(
        fajr: '05:00',
        sunrise: '06:15',
        dhuhr: '12:00',
        asr: '15:30',
        sunset: '18:00',
        maghrib: '18:00',
        isha: '19:15',
        imsak: '04:50',
        midnight: '00:00',
        firstthird: '22:00',
        lastthird: '02:00',
      );

      controller.onSuccess(entity);

      expect(controller.vaJadwal.length, 5);
      expect(controller.vaJadwal.first.hour, 5);
      expect(controller.vaJadwal.first.minute, 0);
    });
  });

  group('getSholatText()', () {
    test(
        'returns "Subuh Besok" when all jadwal times have already passed (hour: 0, minute: 0)',
        () {
      // Validates: Requirements 18.1
      // Setting all times to 00:00 guarantees they are always in the past
      // for any test run after midnight (i.e. always).
      controller.vaJadwal.value = <SetNotifModel>[
        SetNotifModel(
          iconsax: Iconsax.moon1,
          hour: 0,
          minute: 0,
          title: 'Subuh',
          body: 'Waktunya sholat Subuh',
          isAlarmSet: false.obs,
        ),
        SetNotifModel(
          iconsax: Iconsax.sun,
          hour: 0,
          minute: 0,
          title: 'Dzuhur',
          body: 'Waktunya sholat Dzuhur',
          isAlarmSet: false.obs,
        ),
        SetNotifModel(
          iconsax: Iconsax.sun_1,
          hour: 0,
          minute: 0,
          title: 'Ashar',
          body: 'Waktunya sholat Ashar',
          isAlarmSet: false.obs,
        ),
        SetNotifModel(
          iconsax: Iconsax.sun_fog,
          hour: 0,
          minute: 0,
          title: 'Maghrib',
          body: 'Waktunya sholat Maghrib',
          isAlarmSet: false.obs,
        ),
        SetNotifModel(
          iconsax: Iconsax.moon5,
          hour: 0,
          minute: 0,
          title: 'Isya',
          body: 'Waktunya sholat Isya',
          isAlarmSet: false.obs,
        ),
      ];

      expect(controller.getSholatText(), 'Subuh Besok');
    });

    test(
        'returns "Mendekati waktu Subuh" when first jadwal time is in the future',
        () {
      // Validates: Requirements 18.2
      // Compute a same-day future time that is guaranteed to be after now.
      // Using now.minute + 5 with a cap to avoid hour-rollover issues.
      final DateTime now = DateTime.now();
      // Pick a time 5 minutes from now, but stay within the same hour/day.
      // If we're at minute >= 55, add 1 to the hour instead (stays same-day
      // because we only need to be before 23:59 — tested outside midnight).
      final int futureHour =
          now.minute >= 55 ? (now.hour + 1).clamp(0, 22) : now.hour;
      final int futureMinute = now.minute >= 55 ? 0 : now.minute + 5;

      controller.vaJadwal.value = <SetNotifModel>[
        SetNotifModel(
          iconsax: Iconsax.moon1,
          hour: futureHour,
          minute: futureMinute,
          title: 'Subuh',
          body: 'Waktunya sholat Subuh',
          isAlarmSet: false.obs,
        ),
        SetNotifModel(
          iconsax: Iconsax.sun,
          hour: 0,
          minute: 0,
          title: 'Dzuhur',
          body: 'Waktunya sholat Dzuhur',
          isAlarmSet: false.obs,
        ),
      ];

      expect(controller.getSholatText(), 'Mendekati waktu Subuh');
    });
  });

  group('updateCountdown()', () {
    test(
        'countdownText.value tidak kosong dan cocok format "... dalam\\nHH:mm:ss" setelah onSuccess()',
        () {
      // Validates: Requirements 18.3
      // Gunakan waktu 23:59 untuk semua jadwal agar setidaknya satu
      // selalu di masa depan, sehingga updateCountdown() pasti mengisi
      // countdownText dengan format yang benar.
      const entity = JadwalSholatEntity(
        fajr: '23:59',
        sunrise: '23:59',
        dhuhr: '23:59',
        asr: '23:59',
        sunset: '23:59',
        maghrib: '23:59',
        isha: '23:59',
        imsak: '23:59',
        midnight: '23:59',
        firstthird: '23:59',
        lastthird: '23:59',
      );

      controller.onSuccess(entity);
      controller.updateCountdown();

      expect(controller.countdownText.value, isNotEmpty);
      expect(
        RegExp(r'.+\sdalam\n\d{2}:\d{2}:\d{2}')
            .hasMatch(controller.countdownText.value),
        isTrue,
        reason:
            'countdownText "${controller.countdownText.value}" tidak cocok format ".+ dalam\\nHH:mm:ss"',
      );
    });
  });

  group('loadAlarmStatus()', () {
    test(
        'sets isAlarmSet.value = true for Subuh when alarm_Subuh is true in storage',
        () async {
      // Validates: Requirements 18.4
      //
      // loadAlarmStatus() flow:
      //   for each item in vaJadwal:
      //     final status = C.getBool('alarm_${item.title}', false);  // sync
      //     item.isAlarmSet.value = status;                          // sync ← we verify this
      //     if (isAlarmSet.value) await C.scheduleNotification(...); // async, may throw in test
      //
      // Strategy:
      //   1. Populate vaJadwal via onSuccess() (with storage alarm_Subuh=false
      //      so the first onSuccess call doesn't trigger scheduleNotification).
      //   2. Set alarm_Subuh = true in storage.
      //   3. Call loadAlarmStatus() directly inside runZonedGuarded so any
      //      notification-subsystem error is swallowed.
      //   4. Await one microtask cycle — enough for the synchronous loop body
      //      (isAlarmSet assignment) to execute.
      //   5. Verify isAlarmSet.value == true.

      // Step 1: populate vaJadwal (alarm_Subuh is false → no scheduleNotification).
      const entity = JadwalSholatEntity(
        fajr: '05:00',
        sunrise: '06:15',
        dhuhr: '12:00',
        asr: '15:30',
        sunset: '18:00',
        maghrib: '18:00',
        isha: '19:15',
        imsak: '04:50',
        midnight: '00:00',
        firstthird: '22:00',
        lastthird: '02:00',
      );
      controller.onSuccess(entity);

      // Step 2: set storage key.
      await GetStorage().write('alarm_Subuh', true);

      // Step 3 & 4: run loadAlarmStatus() in a guarded zone and await one
      // microtask so the synchronous assignment executes.
      final completer = Completer<void>();
      runZonedGuarded(
        () {
          controller.loadAlarmStatus();
          // Resolve after the synchronous portion of the for-loop runs
          // (before the first await inside the loop).
          Future<void>.microtask(completer.complete);
        },
        (Object error, StackTrace stack) {
          // Swallow errors from the notification subsystem (e.g.
          // LateInitializationError from flutter_local_notifications not
          // being initialised in unit test environment).
          if (!completer.isCompleted) completer.complete();
        },
      );

      await completer.future;

      // Step 5: verify.
      expect(
        controller.vaJadwal.first.isAlarmSet.value,
        isTrue,
        reason:
            'isAlarmSet should be true for Subuh when alarm_Subuh=true in storage',
      );
    });
  });

  group('Property Tests', () {
    test(
        'Property 21: formatDuration always produces HH:mm:ss with correct values',
        () {
      // Feature: unit-testing, Property 21: formatDuration Padding HH:mm:ss
      // **Validates: Requirements 15.1, 15.2**
      for (int i = 0; i < 100; i++) {
        final hours = i % 24;
        final minutes = i % 60;
        final seconds = (i * 7) % 60;
        final duration =
            Duration(hours: hours, minutes: minutes, seconds: seconds);

        final result = controller.formatDuration(duration);

        // Must match HH:mm:ss format
        expect(RegExp(r'^\d{2}:\d{2}:\d{2}$').hasMatch(result), isTrue,
            reason:
                'formatDuration($duration) = "$result" does not match HH:mm:ss');

        // Values must be accurate
        final parts = result.split(':');
        expect(int.parse(parts[0]), duration.inHours,
            reason: 'Hours mismatch for $duration');
        expect(int.parse(parts[1]), duration.inMinutes.remainder(60),
            reason: 'Minutes mismatch for $duration');
        expect(int.parse(parts[2]), duration.inSeconds.remainder(60),
            reason: 'Seconds mismatch for $duration');
      }
    });

    test('Property 22: onSuccess parses fajr time correctly for any HH:MM', () {
      // Feature: unit-testing, Property 22: onSuccess Parsing Waktu Sholat
      // **Validates: Requirements 15.1, 15.2, 15.4**
      for (int i = 0; i < 100; i++) {
        final hour = i % 24;
        final minute = i % 60;
        final fajrStr =
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

        final entity = JadwalSholatEntity(
          fajr: fajrStr,
          sunrise: '06:00',
          dhuhr: '12:00',
          asr: '15:00',
          sunset: '18:00',
          maghrib: '18:00',
          isha: '19:00',
          imsak: '04:00',
          midnight: '00:00',
          firstthird: '22:00',
          lastthird: '02:00',
        );

        controller.onSuccess(entity);

        expect(controller.vaJadwal.first.hour, hour,
            reason: 'Hour mismatch for fajr="$fajrStr"');
        expect(controller.vaJadwal.first.minute, minute,
            reason: 'Minute mismatch for fajr="$fajrStr"');
      }
    });
  });
}
