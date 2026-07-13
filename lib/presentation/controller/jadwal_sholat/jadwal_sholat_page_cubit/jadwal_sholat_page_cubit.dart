import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quran_app/data/datasources/local_storage_service.dart';
import 'package:quran_app/data/datasources/notification_service.dart';
import 'package:quran_app/data/model/set_notif_model.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';

part 'jadwal_sholat_page_state.dart';
part 'jadwal_sholat_page_cubit.freezed.dart';

class JadwalSholatPageCubit extends Cubit<JadwalSholatPageState> {
  JadwalSholatPageCubit({
    required this.storageService,
    required this.notificationService,
  }) : super(const JadwalSholatPageState.initial());

  final LocalStorageService storageService;
  final NotificationService notificationService;
  Timer? _countdownTimer;
  String _cachedTimezone = '';
  JadwalSholatEntity? _cachedEntity; // persists entity across timer ticks

  /// Gets GPS position, timezone, city name — then emits [awaitingSchedule]
  /// or falls back to [loaded] with city 'Tidak diketahui' if GPS fails.
  Future<void> init() async {
    // Skip jika sudah fully loaded → mencegah re-fetch saat tab navigation.
    // Skip jika sedang _Loading → mencegah concurrent GPS requests.
    // TIDAK skip _AwaitingSchedule karena state ini butuh listener di View
    // untuk trigger API jadwal — jika View di-recreate, listener harus re-trigger.
    if (state is _Loaded || state is _Loading) return;

    emit(const JadwalSholatPageState.loading());

    try {
      _cachedTimezone = await FlutterTimezone.getLocalTimezone();
    } catch (_) {
      _cachedTimezone = '';
    }

    final Position? position = await _determinePosition();

    if (position == null) {
      emit(
        JadwalSholatPageState.loaded(
          city: 'Tidak diketahui',
          timezone: _cachedTimezone,
          jadwalList: const <SetNotifModel>[],
          countdownText: '-',
          sholatText: '-',
          timeText: '-',
          entity: _cachedEntity ??
              const JadwalSholatEntity(
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
              ),
        ),
      );
      return;
    }

    final String city = await _getCityName(position);
    emit(
      JadwalSholatPageState.awaitingSchedule(
        city: city,
        latitude: position.latitude,
        longitude: position.longitude,
      ),
    );
  }

  /// Called when [JadwalSholatCubit] emits a success state with new data.
  void onScheduleReceived(final JadwalSholatEntity data) {
    _cachedEntity = data;
    final List<SetNotifModel> jadwalList = parseJadwal(data);
    _applyAlarmStatusAndEmit(jadwalList);
  }

  /// Parses [JadwalSholatEntity] into a list of [SetNotifModel].
  /// Pure function — fully testable without cubit instance.
  static List<SetNotifModel> parseJadwal(final JadwalSholatEntity data) {
    return <SetNotifModel>[
      SetNotifModel(
        iconsax: Iconsax.moon1,
        hour: int.parse(data.fajr.split(':')[0]),
        minute: int.parse(data.fajr.split(':')[1]),
        title: 'Subuh',
        body: 'Waktunya sholat Subuh',
        isAlarmSet: false,
      ),
      SetNotifModel(
        iconsax: Iconsax.sun,
        hour: int.parse(data.dhuhr.split(':')[0]),
        minute: int.parse(data.dhuhr.split(':')[1]),
        title: 'Dzuhur',
        body: 'Waktunya sholat Dzuhur',
        isAlarmSet: false,
      ),
      SetNotifModel(
        iconsax: Iconsax.sun_1,
        hour: int.parse(data.asr.split(':')[0]),
        minute: int.parse(data.asr.split(':')[1]),
        title: 'Ashar',
        body: 'Waktunya sholat Ashar',
        isAlarmSet: false,
      ),
      SetNotifModel(
        iconsax: Iconsax.sun_fog,
        hour: int.parse(data.maghrib.split(':')[0]),
        minute: int.parse(data.maghrib.split(':')[1]),
        title: 'Maghrib',
        body: 'Waktunya sholat Maghrib',
        isAlarmSet: false,
      ),
      SetNotifModel(
        iconsax: Iconsax.moon5,
        hour: int.parse(data.isha.split(':')[0]),
        minute: int.parse(data.isha.split(':')[1]),
        title: 'Isya',
        body: 'Waktunya sholat Isya',
        isAlarmSet: false,
      ),
    ];
  }

  /// Calculates countdown text to next prayer.
  /// Pure function — fully testable.
  static String calculateCountdown(
    final List<SetNotifModel> jadwalList,
    final DateTime now,
  ) {
    for (final SetNotifModel entry in jadwalList) {
      final DateTime waktuSholat = DateTime(
        now.year,
        now.month,
        now.day,
        entry.hour,
        entry.minute,
      );
      if (now.isBefore(waktuSholat)) {
        final Duration remaining = waktuSholat.difference(now);
        return '${entry.title} dalam\n${formatDuration(remaining)}';
      }
    }

    if (jadwalList.isNotEmpty) {
      final DateTime waktuSubuhBesok = DateTime(
        now.year,
        now.month,
        now.day + 1,
        jadwalList.first.hour,
        jadwalList.first.minute,
      );
      final Duration remaining = waktuSubuhBesok.difference(now);
      return 'Subuh dalam\n${formatDuration(remaining)}';
    }

    return '-';
  }

  /// Returns the label of the next upcoming prayer.
  /// Pure function — fully testable.
  static String getSholatText(
    final List<SetNotifModel> jadwalList,
    final DateTime now,
  ) {
    for (final SetNotifModel entry in jadwalList) {
      final DateTime waktuSholat = DateTime(
        now.year,
        now.month,
        now.day,
        entry.hour,
        entry.minute,
      );
      if (now.isBefore(waktuSholat)) {
        return 'Mendekati waktu ${entry.title}';
      }
    }
    return 'Subuh Besok';
  }

  /// Returns the time string (HH:mm) of the next upcoming prayer.
  /// Pure function — fully testable.
  static String getTimeText(
    final List<SetNotifModel> jadwalList,
    final DateTime now,
  ) {
    if (jadwalList.isEmpty) return '-';

    for (final SetNotifModel entry in jadwalList) {
      final DateTime waktuSholat = DateTime(
        now.year,
        now.month,
        now.day,
        entry.hour,
        entry.minute,
      );
      if (now.isBefore(waktuSholat)) {
        return '${entry.hour.toString().padLeft(2, '0')}:'
            '${entry.minute.toString().padLeft(2, '0')}';
      }
    }

    // Fallback to first (Subuh tomorrow)
    final SetNotifModel first = jadwalList.first;
    return '${first.hour.toString().padLeft(2, '0')}:'
        '${first.minute.toString().padLeft(2, '0')}';
  }

  /// Formats a [Duration] as "HH:mm:ss".
  static String formatDuration(final Duration duration) {
    String twoDigits(final int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inHours)}:'
        '${twoDigits(duration.inMinutes.remainder(60))}:'
        '${twoDigits(duration.inSeconds.remainder(60))}';
  }

  /// Toggles notification for a prayer entry at [index].
  Future<void> toggleNotification(
    final int index,
    final SetNotifModel model,
  ) async {
    if (model.isAlarmSet) {
      await notificationService.cancelNotification(index);
      await storageService.setBool(
        key: 'alarm_${model.title}',
        value: false,
      );
    } else {
      await notificationService.scheduleNotification(
        index,
        model.hour,
        model.minute,
        title: model.title,
        body: model.body,
      );
      await storageService.setBool(
        key: 'alarm_${model.title}',
        value: true,
      );
    }

    state.maybeWhen(
      loaded: (
        final String _,
        final String __,
        final List<SetNotifModel> jadwalList,
        final String ___,
        final String ____,
        final String _____,
        final JadwalSholatEntity ______,
      ) =>
          _applyAlarmStatusAndEmit(jadwalList),
      orElse: () {},
    );
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  void _applyAlarmStatusAndEmit(final List<SetNotifModel> jadwalList) {
    final List<SetNotifModel> updatedList = jadwalList.map(
      (final SetNotifModel item) {
        final bool isAlarmSet = storageService.getBool(
          key: 'alarm_${item.title}',
          defaultValue: false,
        );
        return item.copyWith(isAlarmSet: isAlarmSet);
      },
    ).toList();

    final DateTime now = DateTime.now();
    final String countdownText = calculateCountdown(updatedList, now);
    final String sholatText = getSholatText(updatedList, now);
    final String timeText = getTimeText(updatedList, now);

    final String city = state.maybeWhen(
      awaitingSchedule: (final String city, final double _, final double __) =>
          city,
      loaded: (
        final String city,
        final String _,
        final List<SetNotifModel> __,
        final String ___,
        final String ____,
        final String _____,
        final JadwalSholatEntity ______,
      ) =>
          city,
      orElse: () => 'Tidak diketahui',
    );

    final String timezone = state.maybeWhen(
      loaded: (
        final String _,
        final String timezone,
        final List<SetNotifModel> __,
        final String ___,
        final String ____,
        final String _____,
        final JadwalSholatEntity ______,
      ) =>
          timezone,
      orElse: () => _cachedTimezone,
    );

    emit(
      JadwalSholatPageState.loaded(
        city: city,
        timezone: timezone,
        jadwalList: updatedList,
        countdownText: countdownText,
        sholatText: sholatText,
        timeText: timeText,
        entity: _cachedEntity ??
            const JadwalSholatEntity(
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
            ),
      ),
    );

    _startCountdownTimer(updatedList, city, timezone);
  }

  void _startCountdownTimer(
    final List<SetNotifModel> jadwalList,
    final String city,
    final String timezone,
  ) {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (final Timer _) {
        final DateTime now = DateTime.now();
        final String countdownText = calculateCountdown(jadwalList, now);
        final String sholatText = getSholatText(jadwalList, now);
        final String timeText = getTimeText(jadwalList, now);
        emit(
          JadwalSholatPageState.loaded(
            city: city,
            timezone: timezone,
            jadwalList: jadwalList,
            countdownText: countdownText,
            sholatText: sholatText,
            timeText: timeText,
            entity: _cachedEntity ??
                const JadwalSholatEntity(
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
                ),
          ),
        );
      },
    );
  }

  Future<Position?> _determinePosition() async {
    try {
      return await Geolocator.getCurrentPosition();
    } catch (_) {
      return null;
    }
  }

  Future<String> _getCityName(final Position position) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        return placemarks[0].locality ?? 'Tidak diketahui';
      }
    } catch (_) {}
    return 'Tidak diketahui';
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}
