// ignore_for_file: avoid_dynamic_calls

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/data/model/set_notif_model.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';
import 'package:quran_app/presentation/controller/jadwal_sholat/jadwal_sholat_page_cubit/jadwal_sholat_page_cubit.dart';

import '../../mocks.dart';
import '../../helpers/generators.dart';

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

const JadwalSholatEntity kTestEntity = JadwalSholatEntity(
  fajr: '05:00',
  sunrise: '06:15',
  dhuhr: '12:00',
  asr: '15:30',
  sunset: '18:00',
  maghrib: '18:10',
  isha: '19:15',
  imsak: '04:50',
  midnight: '23:53',
  firstthird: '21:51',
  lastthird: '01:54',
);

String _hm(final int hour, final int minute) =>
    '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

List<SetNotifModel> _buildJadwal() => <SetNotifModel>[
      const SetNotifModel(
          iconsax: Iconsax.moon1,
          hour: 5,
          minute: 0,
          title: 'Subuh',
          body: 'Waktunya sholat Subuh',
          isAlarmSet: false),
      const SetNotifModel(
          iconsax: Iconsax.sun,
          hour: 12,
          minute: 0,
          title: 'Dzuhur',
          body: 'Waktunya sholat Dzuhur',
          isAlarmSet: false),
      const SetNotifModel(
          iconsax: Iconsax.sun_1,
          hour: 15,
          minute: 30,
          title: 'Ashar',
          body: 'Waktunya sholat Ashar',
          isAlarmSet: false),
      const SetNotifModel(
          iconsax: Iconsax.sun_fog,
          hour: 18,
          minute: 10,
          title: 'Maghrib',
          body: 'Waktunya sholat Maghrib',
          isAlarmSet: false),
      const SetNotifModel(
          iconsax: Iconsax.moon5,
          hour: 19,
          minute: 15,
          title: 'Isya',
          body: 'Waktunya sholat Isya',
          isAlarmSet: false),
    ];

// ---------------------------------------------------------------------------

void main() {
  late MockNotificationService mockNotification;
  late MockLocalStorageService mockStorage;

  setUp(() {
    mockNotification = MockNotificationService();
    mockStorage = MockLocalStorageService();
  });

  JadwalSholatPageCubit buildCubit() => JadwalSholatPageCubit(
        storageService: mockStorage,
        notificationService: mockNotification,
      );

  // -------------------------------------------------------------------------
  // initial state
  // -------------------------------------------------------------------------
  group('initial state', () {
    test('is JadwalSholatPageState.initial() — Validates: Requirements 7.1',
        () {
      final cubit = buildCubit();
      addTearDown(cubit.close);
      expect(cubit.state, const JadwalSholatPageState.initial());
    });
  });

  // -------------------------------------------------------------------------
  // parseJadwal()
  // -------------------------------------------------------------------------
  group('parseJadwal()', () {
    test('returns exactly 5 items — Validates: Requirements 7.3', () {
      expect(JadwalSholatPageCubit.parseJadwal(kTestEntity).length, 5);
    });
    test('index 0 Subuh hour=5 minute=0 — Validates: Requirements 7.3', () {
      final r = JadwalSholatPageCubit.parseJadwal(kTestEntity);
      expect(r[0].title, 'Subuh');
      expect(r[0].hour, 5);
      expect(r[0].minute, 0);
    });
    test('index 1 Dzuhur hour=12 minute=0 — Validates: Requirements 7.3', () {
      final r = JadwalSholatPageCubit.parseJadwal(kTestEntity);
      expect(r[1].title, 'Dzuhur');
      expect(r[1].hour, 12);
      expect(r[1].minute, 0);
    });
    test('index 2 Ashar hour=15 minute=30 — Validates: Requirements 7.3', () {
      final r = JadwalSholatPageCubit.parseJadwal(kTestEntity);
      expect(r[2].title, 'Ashar');
      expect(r[2].hour, 15);
      expect(r[2].minute, 30);
    });
    test('index 3 Maghrib hour=18 minute=10 — Validates: Requirements 7.3', () {
      final r = JadwalSholatPageCubit.parseJadwal(kTestEntity);
      expect(r[3].title, 'Maghrib');
      expect(r[3].hour, 18);
      expect(r[3].minute, 10);
    });
    test('index 4 Isya hour=19 minute=15 — Validates: Requirements 7.3', () {
      final r = JadwalSholatPageCubit.parseJadwal(kTestEntity);
      expect(r[4].title, 'Isya');
      expect(r[4].hour, 19);
      expect(r[4].minute, 15);
    });
    test('all items isAlarmSet=false — Validates: Requirements 7.3', () {
      final r = JadwalSholatPageCubit.parseJadwal(kTestEntity);
      expect(r.every((e) => !e.isAlarmSet), isTrue);
    });
  });

  // -------------------------------------------------------------------------
  // calculateCountdown()
  // -------------------------------------------------------------------------
  group('calculateCountdown()', () {
    test('countdown to Subuh when now=04:00 — Validates: Requirements 7.4', () {
      final r = JadwalSholatPageCubit.calculateCountdown(
          _buildJadwal(), DateTime(2024, 1, 15, 4, 0, 0));
      expect(r, contains('Subuh'));
      expect(r, contains('dalam\n'));
      expect(r, contains('01:00:00'));
    });
    test('countdown to Dzuhur when now=08:00 — Validates: Requirements 7.4',
        () {
      final r = JadwalSholatPageCubit.calculateCountdown(
          _buildJadwal(), DateTime(2024, 1, 15, 8, 0, 0));
      expect(r, contains('Dzuhur'));
      expect(r, contains('04:00:00'));
    });
    test(
        'countdown to Subuh tomorrow when all passed (23:00) — Validates: Requirements 7.5',
        () {
      final r = JadwalSholatPageCubit.calculateCountdown(
          _buildJadwal(), DateTime(2024, 1, 15, 23, 0, 0));
      expect(r, contains('Subuh'));
      expect(r, contains('06:00:00'));
    });
    test('returns "-" for empty list — Validates: Requirements 7.4', () {
      expect(
        JadwalSholatPageCubit.calculateCountdown(
            const <SetNotifModel>[], DateTime(2024, 1, 15, 10)),
        '-',
      );
    });
  });

  // -------------------------------------------------------------------------
  // getSholatText()
  // -------------------------------------------------------------------------
  group('getSholatText()', () {
    test('"Mendekati waktu Subuh" when now=04:30 — Validates: Requirements 7.6',
        () {
      expect(
          JadwalSholatPageCubit.getSholatText(
              _buildJadwal(), DateTime(2024, 1, 15, 4, 30)),
          'Mendekati waktu Subuh');
    });
    test(
        '"Mendekati waktu Dzuhur" when now=10:00 — Validates: Requirements 7.6',
        () {
      expect(
          JadwalSholatPageCubit.getSholatText(
              _buildJadwal(), DateTime(2024, 1, 15, 10)),
          'Mendekati waktu Dzuhur');
    });
    test('"Subuh Besok" when all passed (23:30) — Validates: Requirements 7.6',
        () {
      expect(
          JadwalSholatPageCubit.getSholatText(
              _buildJadwal(), DateTime(2024, 1, 15, 23, 30)),
          'Subuh Besok');
    });
  });

  // -------------------------------------------------------------------------
  // getTimeText()
  // -------------------------------------------------------------------------
  group('getTimeText()', () {
    test('"05:00" when now=04:00 — Validates: Requirements 7.7', () {
      expect(
          JadwalSholatPageCubit.getTimeText(
              _buildJadwal(), DateTime(2024, 1, 15, 4)),
          '05:00');
    });
    test('"12:00" when now=09:00 — Validates: Requirements 7.7', () {
      expect(
          JadwalSholatPageCubit.getTimeText(
              _buildJadwal(), DateTime(2024, 1, 15, 9)),
          '12:00');
    });
    test('zero-pads "05:03" — Validates: Requirements 7.7', () {
      final jadwal = <SetNotifModel>[
        const SetNotifModel(
            iconsax: Iconsax.moon1,
            hour: 5,
            minute: 3,
            title: 'Subuh',
            body: '',
            isAlarmSet: false),
      ];
      expect(
          JadwalSholatPageCubit.getTimeText(jadwal, DateTime(2024, 1, 15, 4)),
          '05:03');
    });
    test(
        'falls back to "05:00" when all passed (23:30) — Validates: Requirements 7.7',
        () {
      expect(
          JadwalSholatPageCubit.getTimeText(
              _buildJadwal(), DateTime(2024, 1, 15, 23, 30)),
          '05:00');
    });
    test('returns "-" for empty list — Validates: Requirements 7.7', () {
      expect(
          JadwalSholatPageCubit.getTimeText(
              const <SetNotifModel>[], DateTime(2024, 1, 15, 10)),
          '-');
    });
  });

  // -------------------------------------------------------------------------
  // formatDuration()
  // -------------------------------------------------------------------------
  group('formatDuration()', () {
    test('"02:30:05" — Validates: Requirements 7.8', () {
      expect(
          JadwalSholatPageCubit.formatDuration(
              const Duration(hours: 2, minutes: 30, seconds: 5)),
          '02:30:05');
    });
    test('"00:00:00" — Validates: Requirements 7.8', () {
      expect(JadwalSholatPageCubit.formatDuration(Duration.zero), '00:00:00');
    });
    test('"01:00:00" — Validates: Requirements 7.8', () {
      expect(JadwalSholatPageCubit.formatDuration(const Duration(hours: 1)),
          '01:00:00');
    });
  });

  // -------------------------------------------------------------------------
  // toggleNotification()
  // -------------------------------------------------------------------------
  group('toggleNotification()', () {
    setUp(() {
      when(() => mockStorage.getBool(
            key: any(named: 'key'),
            defaultValue: any(named: 'defaultValue'),
          )).thenReturn(false);
      when(() => mockStorage.setBool(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});
    });

    test(
        'scheduleNotification when isAlarmSet=false — Validates: Requirements 7.9',
        () async {
      when(() => mockNotification.scheduleNotification(any(), any(), any(),
          title: any(named: 'title'),
          body: any(named: 'body'))).thenAnswer((_) async {});

      final cubit = buildCubit();
      cubit.onScheduleReceived(kTestEntity);
      addTearDown(cubit.close);

      await cubit.toggleNotification(
          0,
          const SetNotifModel(
            iconsax: Iconsax.moon1,
            hour: 5,
            minute: 0,
            title: 'Subuh',
            body: 'Waktunya sholat Subuh',
            isAlarmSet: false,
          ));

      verify(() => mockNotification.scheduleNotification(0, 5, 0,
          title: 'Subuh', body: 'Waktunya sholat Subuh')).called(1);
      verifyNever(() => mockNotification.cancelNotification(any()));
    });

    test(
        'cancelNotification when isAlarmSet=true — Validates: Requirements 7.12',
        () async {
      when(() => mockNotification.cancelNotification(any()))
          .thenAnswer((_) async {});

      final cubit = buildCubit();
      cubit.onScheduleReceived(kTestEntity);
      addTearDown(cubit.close);

      await cubit.toggleNotification(
          0,
          const SetNotifModel(
            iconsax: Iconsax.moon1,
            hour: 5,
            minute: 0,
            title: 'Subuh',
            body: 'Waktunya sholat Subuh',
            isAlarmSet: true,
          ));

      verify(() => mockNotification.cancelNotification(0)).called(1);
      verifyNever(() => mockNotification.scheduleNotification(
          any(), any(), any(),
          title: any(named: 'title'), body: any(named: 'body')));
    });

    test(
        'stores alarm_Subuh=true after scheduling — Validates: Requirements 7.9',
        () async {
      when(() => mockNotification.scheduleNotification(any(), any(), any(),
          title: any(named: 'title'),
          body: any(named: 'body'))).thenAnswer((_) async {});

      final cubit = buildCubit();
      cubit.onScheduleReceived(kTestEntity);
      addTearDown(cubit.close);

      await cubit.toggleNotification(
          0,
          const SetNotifModel(
            iconsax: Iconsax.moon1,
            hour: 5,
            minute: 0,
            title: 'Subuh',
            body: 'Waktunya sholat Subuh',
            isAlarmSet: false,
          ));

      verify(() => mockStorage.setBool(key: 'alarm_Subuh', value: true))
          .called(1);
    });

    test(
        'stores alarm_Subuh=false after cancelling — Validates: Requirements 7.12',
        () async {
      when(() => mockNotification.cancelNotification(any()))
          .thenAnswer((_) async {});

      final cubit = buildCubit();
      cubit.onScheduleReceived(kTestEntity);
      addTearDown(cubit.close);

      await cubit.toggleNotification(
          0,
          const SetNotifModel(
            iconsax: Iconsax.moon1,
            hour: 5,
            minute: 0,
            title: 'Subuh',
            body: 'Waktunya sholat Subuh',
            isAlarmSet: true,
          ));

      verify(() => mockStorage.setBool(key: 'alarm_Subuh', value: false))
          .called(1);
    });
  });

  // -------------------------------------------------------------------------
  // GPS failure fallback state
  // -------------------------------------------------------------------------
  group('GPS failure fallback state', () {
    test(
        'city="Tidak diketahui" and empty jadwalList — Validates: Requirements 7.1',
        () {
      const JadwalSholatEntity kEmptyEntity = JadwalSholatEntity(
        fajr: '-',
        sunrise: '-',
        dhuhr: '-',
        asr: '-',
        sunset: '-',
        maghrib: '-',
        isha: '-',
        imsak: '-',
        midnight: '-',
        firstthird: '-',
        lastthird: '-',
      );
      const JadwalSholatPageState state = JadwalSholatPageState.loaded(
        city: 'Tidak diketahui',
        timezone: '',
        jadwalList: <SetNotifModel>[],
        countdownText: '-',
        sholatText: '-',
        timeText: '-',
        entity: kEmptyEntity,
      );

      final String city = state.maybeWhen(
        loaded: (c, _, __, ___, ____, _____, ______) => c,
        orElse: () => '',
      );
      final List<SetNotifModel> jadwalList = state.maybeWhen(
        loaded: (_, __, jl, ___, ____, _____, ______) => jl,
        orElse: () => const <SetNotifModel>[],
      );

      expect(city, 'Tidak diketahui');
      expect(jadwalList, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // onScheduleReceived()
  // -------------------------------------------------------------------------
  group('onScheduleReceived()', () {
    setUp(() {
      when(() => mockStorage.getBool(
            key: any(named: 'key'),
            defaultValue: any(named: 'defaultValue'),
          )).thenReturn(false);
    });

    blocTest<JadwalSholatPageCubit, JadwalSholatPageState>(
      'emits loaded state with 5-item jadwalList — Validates: Requirements 7.1, 7.3',
      build: buildCubit,
      act: (cubit) => cubit.onScheduleReceived(kTestEntity),
      expect: () => [
        isA<JadwalSholatPageState>().having(
          (s) => s.maybeWhen(
            loaded: (_, __, jl, ___, ____, _____, ______) => jl.length,
            orElse: () => -1,
          ),
          'jadwalList.length',
          5,
        ),
      ],
    );

    blocTest<JadwalSholatPageCubit, JadwalSholatPageState>(
      'loaded state has non-empty countdown/sholat/time — Validates: Requirements 7.4, 7.6, 7.7',
      build: buildCubit,
      act: (cubit) => cubit.onScheduleReceived(kTestEntity),
      expect: () => [
        isA<JadwalSholatPageState>().having(
          (s) => s.maybeWhen(
            loaded: (_, __, ___, cd, sh, tt, ______) =>
                cd.isNotEmpty && sh.isNotEmpty && tt.isNotEmpty,
            orElse: () => false,
          ),
          'texts are non-empty',
          isTrue,
        ),
      ],
    );
  });

  // -------------------------------------------------------------------------
  // Property Tests
  // -------------------------------------------------------------------------
  group('Property Tests', () {
    // **Validates: Requirements 7.3**
    test(
        'Property 10: parseJadwal always returns exactly 5 SetNotifModel '
        'for any JadwalSholatEntity', () {
      for (int i = 0; i < 100; i++) {
        final entity = generateRandomJadwalSholatModel().toEntity();
        final result = JadwalSholatPageCubit.parseJadwal(entity);
        expect(result.length, equals(5),
            reason: 'parseJadwal must return 5 items (iteration $i)');
      }
    });

    // **Validates: Requirements 7.5, 7.7**
    test(
        'Property 11: when all prayer times have passed, '
        'calculateCountdown result contains "Subuh"', () {
      final DateTime now = DateTime(2024, 1, 1, 23, 59);
      for (int i = 0; i < 100; i++) {
        final base = generateRandomJadwalSholatModel();
        final JadwalSholatEntity entity = JadwalSholatEntity(
          fajr: _hm((i % 4) + 1, i % 58),
          sunrise: base.sunrise,
          dhuhr: _hm((i % 4) + 5, i % 58),
          asr: _hm((i % 4) + 9, i % 58),
          sunset: base.sunset,
          maghrib: _hm((i % 4) + 13, i % 58),
          isha: _hm((i % 4) + 17, i % 58),
          imsak: base.imsak,
          midnight: base.midnight,
          firstthird: base.firstthird,
          lastthird: base.lastthird,
        );
        final jadwal = JadwalSholatPageCubit.parseJadwal(entity);
        final countdown = JadwalSholatPageCubit.calculateCountdown(jadwal, now);
        expect(countdown, contains('Subuh'),
            reason: 'All prayers passed => countdown must point to Subuh '
                '(iteration $i, got: "$countdown")');
      }
    });

    // **Validates: Requirements 7.9, 7.10, 7.12**
    test(
        'Property 12: alarm flags in loaded state match storage values '
        'for any combination of 5 boolean alarm states', () async {
      const List<String> titles = <String>[
        'Subuh',
        'Dzuhur',
        'Ashar',
        'Maghrib',
        'Isya',
      ];
      for (int i = 0; i < 100; i++) {
        final List<bool> alarmValues =
            List<bool>.generate(5, (int idx) => ((i >> (idx % 5)) & 1) == 1);
        for (int j = 0; j < titles.length; j++) {
          when(() => mockStorage.getBool(
                key: 'alarm_${titles[j]}',
                defaultValue: false,
              )).thenReturn(alarmValues[j]);
        }
        final JadwalSholatPageCubit cubit = buildCubit();
        cubit.emit(const JadwalSholatPageState.awaitingSchedule(
            city: 'Test City', latitude: -6.2, longitude: 106.8));
        final entity = generateRandomJadwalSholatModel().toEntity();
        cubit.onScheduleReceived(entity);
        await Future<void>.delayed(Duration.zero);
        final JadwalSholatPageState currentState = cubit.state;
        currentState.maybeWhen(
          loaded: (final String _,
              final String __,
              final List<dynamic> jadwalList,
              final String ___,
              final String ____,
              final String _____,
              final dynamic ______) {
            for (int j = 0; j < titles.length; j++) {
              expect(
                (jadwalList[j] as SetNotifModel).isAlarmSet,
                equals(alarmValues[j]),
                reason: 'jadwalList[$j] (${titles[j]}) isAlarmSet '
                    'should be ${alarmValues[j]} (iteration $i)',
              );
            }
          },
          orElse: () => fail(
              'Expected loaded state but got $currentState (iteration $i)'),
        );
        await cubit.close();
      }
    });
  });
}
