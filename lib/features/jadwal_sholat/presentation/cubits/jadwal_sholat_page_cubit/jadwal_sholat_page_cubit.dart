import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/core/constants/config.dart';
import 'package:quran_app/core/services/location_service.dart';
import 'package:quran_app/core/storage/local_storage_service.dart';
import 'package:quran_app/core/services/notification_service.dart';
import 'package:quran_app/data/model/set_notif_model.dart';
import 'package:quran_app/features/jadwal_sholat/domain/entities/jadwal_sholat_entity.dart';
import 'package:quran_app/features/jadwal_sholat/presentation/helpers/prayer_time_helpers.dart';

part 'jadwal_sholat_page_state.dart';
part 'jadwal_sholat_page_cubit.freezed.dart';

class JadwalSholatPageCubit extends Cubit<JadwalSholatPageState> {
  JadwalSholatPageCubit({
    required this.storageService,
    required this.notificationService,
    required this.locationService,
  }) : super(const JadwalSholatPageState.initial());

  final LocalStorageService storageService;
  final NotificationService notificationService;
  final LocationService locationService;
  Timer? _countdownTimer;
  String _cachedTimezone = '';
  JadwalSholatEntity? _cachedEntity;

  int _retryCount = 0;
  static const int _maxRetries = 3;

  /// Gets GPS position, timezone, city name — then emits [awaitingSchedule]
  /// or emits [locationError]/[locationPermissionError] if GPS fails.
  Future<void> init() async {
    if (state is _Loaded || state is _Loading) return;

    emit(const JadwalSholatPageState.loading());

    _cachedTimezone = await locationService.getLocalTimezone();

    final position = await locationService.getCurrentPosition();

    if (position == null) {
      _retryCount++;
      if (_retryCount >= _maxRetries) {
        emit(
          const JadwalSholatPageState.locationPermissionError(
            message:
                'Gagal mendapatkan lokasi setelah 3 percobaan. Periksa pengaturan lokasi di perangkat Anda.',
          ),
        );
      } else {
        emit(
          JadwalSholatPageState.locationError(
            message: 'Gagal mendapatkan lokasi. Ketuk untuk coba lagi.',
            retryCount: _retryCount,
          ),
        );
      }
      return;
    }

    _retryCount = 0;

    final String city = await locationService.getCityName(
      position.latitude,
      position.longitude,
    );
    emit(
      JadwalSholatPageState.awaitingSchedule(
        city: city,
        latitude: position.latitude,
        longitude: position.longitude,
      ),
    );
  }

  /// Retries GPS location acquisition after a failure.
  void retryInit() => init();

  /// Called when [JadwalSholatCubit] emits a success state with new data.
  void onScheduleReceived(final JadwalSholatEntity data) {
    _cachedEntity = data;
    final List<SetNotifModel> jadwalList = PrayerTimeHelpers.parseJadwal(data);
    _applyAlarmStatusAndEmit(jadwalList);
  }

  /// Toggles notification for a prayer entry at [index].
  Future<void> toggleNotification(
    final int index,
    final SetNotifModel model,
  ) async {
    if (model.isAlarmSet) {
      await notificationService.cancelNotification(index);
      await storageService.setBool(
        key: config.alarmKey(model.title),
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
        key: config.alarmKey(model.title),
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
          key: config.alarmKey(item.title),
          defaultValue: false,
        );
        return item.copyWith(isAlarmSet: isAlarmSet);
      },
    ).toList();

    final DateTime now = DateTime.now();

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
        countdownText: PrayerTimeHelpers.calculateCountdown(updatedList, now),
        sholatText: PrayerTimeHelpers.getSholatText(updatedList, now),
        timeText: PrayerTimeHelpers.getTimeText(updatedList, now),
        entity: _cachedEntity ?? _emptyEntity,
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
        emit(
          JadwalSholatPageState.loaded(
            city: city,
            timezone: timezone,
            jadwalList: jadwalList,
            countdownText:
                PrayerTimeHelpers.calculateCountdown(jadwalList, now),
            sholatText: PrayerTimeHelpers.getSholatText(jadwalList, now),
            timeText: PrayerTimeHelpers.getTimeText(jadwalList, now),
            entity: _cachedEntity ?? _emptyEntity,
          ),
        );
      },
    );
  }

  static const _emptyEntity = JadwalSholatEntity(
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

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}
